---
title: activeEffect 摆放位置
tag:
  - diary
  - Vue
description: activeEffect 这个状态改变是应该放在 effect 函数内部还是 effect 对象的 run 函数内部
---

# {{ $frontmatter.title }}

## 起

这是我最开始写 `miniVue` 的时候的 `activeEffect` 摆放位置，可以看到是在 `effect` 函数内部，而 `vue/core`
中摆放在了 `effect` 对象的 `run` 函数内部，我就思考我这个问题出在了哪里，最开始的结论是

- 将 `activeEffect` 放在 `effect` 函数内部，会省去很多的变量，比如 `isTracking` 等

```ts
export class ReactiveEffect {
  private _fn: Function;
  public scheduler: Function | undefined;
  public onStop: Function | undefined;
  public depsList: Deps[];

  constructor(fn: Function, opts?: EffectOpts) {
    this._fn = fn;
    this.scheduler = opts?.scheduler;
    this.onStop = opts?.onStop;
    this.depsList = [];
  }

  run() {
    return this._fn();
  }

  stop() {
    for (const deps of this.depsList) {
      deps.delete(this);
    }
    this.depsList = [];
    this.onStop?.();
  }
}

export function effect(fn: Function, opts?: EffectOpts): ReactiveEffectRunner {
  const _effect = new ReactiveEffect(fn, opts);
  activeEffect = _effect;
  _effect.run();
  activeEffect = null;

  const runner: ReactiveEffectRunner = _effect.run.bind(_effect) as ReactiveEffectRunner;
  runner.effect = _effect;
  return runner;
}

```

## 终

但是做到 `computed` 的时候，我才发现这样做是有问题的，因为 `computed` 内部有一个 `effect`实例，这个实例不是通过
`effect` 函数进行创建的，而是单独调用构造函数得到的，因此访问其中的响应式变量 (通过调用传入构造函数的变量 `fn`) 来进行依赖收集时，track
根本不会执行 (因为没有调用 `effect`， `activeEffect` 为 `null`)

```ts
export function track(target: object, key: PropertyKey) {
  if (!activeEffect) return;
  const deps = getDeps(target, key);
  trackEffect(deps);
}
```

用一个例子来说明这个问题

```ts:line-numbers
const a = reactive({ foo: 1 });
let cnt = 0;
const b = computed(() => {
  cnt++;
  return a.foo + 1;
});
b.value;
```

执行第三行的时候，只是简单的返回了一个 `computedImpl` 对象，将我们传入的函数 `fn` 赋值给了 `computedImpl` 的
`effect` 属性，此时没有执行 `fn`

```ts
constructor(fn: Function) {
  this._effect = new ReactiveEffect(fn, {
    scheduler: () => (this._dirty = true),
  });
}
```

执行到第七行时，我们访问了 `b.value`，此时因为是初次访问，`_dirty` 为 `true`，所以会执行 `effect` 的 `run`
操作，此时代码如下

```ts
get value() {
  if (this._dirty) {
    this._dirty = false;
    this._value = this._effect.run();
  }

  return this._value;
}
```

然后我们就进入到了 `effect` 的 `run` 函数中，去执行我们传入的 `fn`

```ts
run() {
  return this._fn();
}
```

执行 `fn` 时访问了响应式对象 `a` 的 `foo` 属性，此时会执行 `track` 函数

```ts
() => {
  cnt++;
  return a.foo + 1;
});
```

```ts
return function getter(target: object, key: PropertyKey): any {
  if (key == ReactiveFlags.IS_READONLY) {
    return isReadonly;
  } else if (key == ReactiveFlags.IS_REACTIVE) {
    return !isReadonly;
  }

  const res = Reflect.get(target, key);
  if (isObject(res) && !isShallow) {
    return isReadonly ? readonly(res) : reactive(res);
  }

  if (!isReadonly) {
    track(target, key);
  }
  return res;
};
```

但是 `activeEffect` 为 `null`，所以 `track` 函数不会执行，也就不会进行依赖收集，最终导致 `computed` 的
`effect` 依赖收集失败

```ts
export function track(target: object, key: PropertyKey) {
  if (!activeEffect) return;
  const deps = getDeps(target, key);
  trackEffect(deps);
}
```

最终，后面改变响应式变量的值时，`trigger` 函数虽然执行了，但是因为没有依赖，所以也就没有执行 `effect` 的 `scheduler`，导致
`computed` 失效

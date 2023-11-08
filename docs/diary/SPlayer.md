---
title: SPlayer 编写历程
tag:
  - diary
description: SPlayer 编写历程
---

# {{ $frontmatter.title }}

## 雏形

`2023-11-02`

完成了最后一部分，链接如下

[Splayer 雏形](https://github.com/shellRaining/SPlayer/tree/520a13a8c3d2aaeee78754d7af36ec04120f1c3a?search=1)

## 组件化

`2023-11-06`

其实这个播放器应该一周之前就已经完成了，但是这是一个总共有七百行的文件，维护起来已经感觉到吃力，所以打算进行一下拆分，
目前感觉每个文件中一百到二百行代码最好，并且功能要尽可能的分开，便于后续维护

第一步打算先将控制按钮移动到文件中，但是因为每个组件和播放器状态息息相关，感觉后续可能需要 `pinia` 来进行状态管理，先暂时通过属性传递来实现吧

`2023-11-08`

现在修改了思路，没有直接操作 DOM，而是通过 `pinia` 定义播放器状态，然后通过方法修改播放器状态，最后通过 `watch` 来监听状态的变化，然后进行
DOM 操作，这似乎也符合 `Vue` 的设计思路

<img width='200px' src='https://cn.vuejs.org/assets/state-flow.a8bc738e.png'>

但同时我也遇到了很多问题，比如说

1. 在方法中我可能同时改变两个被监察的状态，而这两个 `watch` 的执行顺序是怎样的

   ```ts {3,4}
   function jump(idx: number, opts?: { stop?: boolean }) {
     // ...
     playerState.value.idx = idx;
     playerState.value.stop = opts?.stop ?? false;
     playerState.value.error = false;
     playerState.value.progress = 0;
     playerState.value.bufferedProgress = 0;
     playerState.value.duration = 0;
     playerState.value.lyric = parseLrc(playerState.value.playList[idx].lyric);
   }
   ```

   ```ts {5,14}
   watch(
     () => playerState.value.stop,
     (stop) => {
       if (player.value == null || playerState.value.idx == -1 || player.value.src == '') return;
       stop ? player.value.pause() : player.value.play();
     }
   );

   watch(
     () => playerState.value.playList[playerState.value.idx],
     (curMusicInfo, oldMusicInfo) => {
       // ...
       const musicPath = new URL(curMusicInfo.link, import.meta.url).href;
       player.value.src = musicPath;

       if (oldMusicInfo == null) {
         player.value.play();
       } else {
         playerState.value.stop ? player.value.pause() : player.value.play();
       }
     }
   );
   ```

在这里，如果我开始从初始状态播放一个音乐，如果第一个 watch 先执行 (在不判断音乐链接时)，那么首先会执行一次
`play`，但此时链接还没有加载完成，所以会报错，然后第二个 watch 会执行，此时链接已经加载完成，所以会再次执行一次
`play`，这样就会导致播放器一开始就会播放两次，出现浏览器报错

而实际情况也是这样，先改变的状态一般是后执行
`watch`，类似的问题如下链接，[similar link](https://stackoverflow.com/questions/51155011/vuejs-watcher-order)

2. 对对象内容的比较

```ts
(curMode) => {
  const curPlayList = playerState.value.playList;
  if (curMode.id == mode.loopSingle.id) {}
}
```

不要直接比较形参，应该比较里面的内容

3. 要不要使用 JSON 来获取图标的路径

   经过实践，不应该使用 JSON 格式来获取图标的路径，因为这样会导致图标的路径不是相对于当前文件的路径，而是 JSON
   中的固定字符串，这样会导致无法解析，比较好的实践是直接通过 `import` 来引入图标，让打包工具来处理路径的问题

1. `<audio>` 对象的事件发生时机和状态改变时机

   如果想要获取新加载的音乐 duration，应该在 `loadeddata` 事件处理后获取，而不是在 `play` 阶段

1. Vue CSS 过渡动画问题

   暂未解决

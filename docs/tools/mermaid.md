---
title: mermaid 使用方法
tag:
  - tools
  - mermaid
description: 因为分析源码还有软件工程需要画很多的流程图，所以找了一个能够通过代码生成的工具。这次选用的是 mermaid
outline: deep
---

# {{ $frontmatter.title }}

生成流程图的工具有 dot 和 mermaid，这次选用的是 mermaid。本文主要记录 mermaid 和 vitepress 集成还有他的使用方法。

## 1.1 mermaid 和 vitepress 集成

1. 按照官网的介绍的方法 [mermaid start](https://emersonbottero.github.io/vitepress-plugin-mermaid/guide/getting-started.html)

```bash
npm install @mermaid-js/mermaid-mindmap@9.3.0 mermaid@9.1.0 vitepress-plugin-mermaid@2.0.10
```

::: warning
在写本文时，mermaid 的最新版本已经到了 `10.2.4`，但是 `vitepress-plugin-mermaid` 还没有更新，所以需要指定 `mermaid@9.1.0`。

但是请注意， mermaid 9.1.0 具有高危漏洞

而且在 config.js 文件中引入的时候，会出现 LSP 的 warning 信息，这也许和作者 npm 包上传的问题有关，也许你可以帮他改进一下。
:::

2. 在 `docs/.vitepress/config.js` 中添加配置，其中 mermaid 配置可以参考 [mermaidAPI configuration defaults](https://mermaid.js.org/config/setup/modules/mermaidAPI.html#mermaidapi-configuration-defaults)

```js
// .vitepress/config.js
import { defineConfig } from "vitepress";
import { withMermaid } from "vitepress-plugin-mermaid";

export default withMermaid(
  defineConfig({
    // your existing vitepress config...
    // optionally, you can pass MermaidConfig
    mermaid: {
      // ...
    },
  })
);
```

3. 测试

如果要输入 mermaid 类型的代码，需要在代码块中添加 `mmd` 类型

```mmd
flowchart LR
  Start --> Stop
```

如果要转换成 mermaid 的 SVG 图片，需要在代码块中添加 `mermaid` 类型

```mermaid
flowchart LR
  Start --> Stop
```

## 1.2 mermaid 使用方法

这里暂时只给出三个例子，具体可以看其他的文章

### 1.2.1 流程图

```mmd
graph TD
  A[Christmas] -->|Get money| B(Go shopping)
  B --> C{Let me think}
  C -->|One| D[Laptop]
  C -->|Two| E[iPhone]
  C -->|Three| F[fa:fa-car Car]
```

更多信息见 [mermaid 流程图](./flowchart)

### 1.2.2 时序图

```mmd
sequenceDiagram
  participant Alice
  participant Bob
  Alice->>John: Hello John, how are you?
  loop Healthcheck
    John->>John: Fight against hypochondria
  end
  Note right of John: Rational thoughts <br/>prevail...
  John-->>Alice: Great!
  John->>Bob: How about you?
  Bob-->>John: Jolly good!
```

### 1.2.3 甘特图

```mmd
gantt
    section Section
    Completed :done,    des1, 2014-01-06,2014-01-08
    Active        :active,  des2, 2014-01-07, 3d
    Parallel 1   :         des3, after des1, 1d
    Parallel 2   :         des4, after des1, 1d
    Parallel 3   :         des5, after des3, 1d
    Parallel 4   :         des6, after des4, 1d
```

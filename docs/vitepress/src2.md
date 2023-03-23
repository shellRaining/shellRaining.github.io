---
title: 阅读 sugar theme 源代码2（源代码 node.ts）
tag:
  - vitepress
description: 本站使用的主题就是 sugar，但是和我的目标不符合，所以希望阅读源码并修改，此处为第一步：阅读源码
---

# {{ $frontmatter.title }}

## 模块引入

```typescript
import glob from "fast-glob";
import matter from "gray-matter";
import fs from "fs";
import { execSync, spawn } from "child_process";
import path from "path";

import type { UserConfig } from "vitepress";
import type { Theme } from "./composables/config/index";
import { formatDate } from "./utils/index";
```

`fast-glob` 提供了一种快速的方式来进行文件系统的 glob 匹配，支持忽略某些文件或目录，以及按照不同的排序规则进行文件的排序。`Glob` 是一种用于匹配文件路径的模式字符串，它可以用来匹配文件、目录或者它们的组合。

`gray-matter` 可以解析文本文件中的 Front Matter 数据，提取出 YAML、TOML 或 JSON 格式的数据，同时还能返回剩余的内容作为字符串。Front Matter 是指存储在文本文件的开头部分，通常用于存储文档的元数据（例如标题、标签、作者等）。

`fs` 是 node 里面内置的库，用来提供文件系统相关的操作，包括读取，写入，更改文件权限等。

`child_process` 是 node 里面内置的库，通过解构赋值的方式倒入了两个函数，`execSync` 是用来同步执行子进程命令的函数，它会阻塞当前进程，直到子进程完成执行并返回结果。它通常用于执行一些简单的命令，例如在命令行中执行一些 shell 命令。`spawn` 是一个异步创建子进程的函数，它会返回一个 ChildProcess 对象，该对象可以用于与子进程进行交互。它通常用于执行一些需要长时间运行的命令，例如启动一个服务器进程。

`path` 也是内置库，提供了一些有关文件路径处理的实用函数。它可以用于处理文件路径的格式、拼接、解析等操作。

`import type` 表示导入的是类型声明，而不是实际的模块。它告诉编译器在编译时只需要处理类型信息，而不需要将相应的模块代码打包到输出文件中。

## getThemeConfig 函数

### 函数内部第一层

```typescript
export function getThemeConfig(cfg?: Partial<Theme.BlogConfig>) {
  const srcDir = cfg?.srcDir || process.argv.slice(2)?.[1] || ".";
  const files = glob.sync(`${srcDir}/**/*.md`, { ignore: ["node_modules"] });

  const data = files
    .map((v) => {
      // do some thing
    })
    .filter((v) => v.meta.layout !== "home");

  return {
    blog: {
      pagesData: data as Theme.PageData[],
      ...cfg,
    },
    sidebar: [
      {
        text: "",
        items: [],
      },
    ],
  };
}
```

这段代码首先获取 markdown 文件所处的目录，可以由用户传入参数指定，或者 node 运行时输入的参数指定，或者默认当前文件所在目录

然后通过 glob 库的 sync 函数获取 srcDir 中除了 node_modules 中所有的 markdown 文件

:::info
"glob.sync" 用于匹配指定模式的文件路径。返回匹配到的文件路径列表，这是一个字符串数组，每个字符串表示一个文件的绝对路径或相对路径，可以通过对这些路径进行遍历和处理，实现各种文件操作。

函数的基本语法为：

```javascript
glob.sync(pattern, [options]);
```

其中，"pattern" 参数表示文件路径匹配模式，支持通配符、正则表达式等语法。 options 是一个对象，包含一些用于控制查找行为的配置项，例如 "ignore" 表示忽略的文件路径列表、"cwd" 表示查找的目录等等。

"glob.sync" 函数会阻塞主线程，直到查找完成并返回结果，因此它是一个同步的函数。
:::

对于每个找到的文件，解析文件内容，提取元数据并将其添加到 `data` 数组中，其中过滤掉了 "meta.layout" 为 "home" 的文章（即首页）。

返回一个包含博客页面数据和侧边栏数据的配置对象。

### 函数内层第二层（map 函数中）

```typescript
files.map((v) => {
  // 处理文件后缀名
  let route = v.replace('.md', '')

  // 去除 srcDir 处理目录名
  if (route.startsWith('./')) {
    const reg = new RegExp(
      `^\\.\\/${path
        .join(srcDir, '/')
        .replace(new RegExp(`\\${path.sep}`, 'g'), '/')}`
    )
    route = route.replace(reg, '')
  } else {
    route = route.replace(
      new RegExp(
        `^${path
          .join(srcDir, '/')
          .replace(new RegExp(`\\${path.sep}`, 'g'), '/')}`
      ),
      ''
    )
  }

  const fileContent = fs.readFileSync(v, 'utf-8')

  // TODO: 支持JSON
  const meta: Partial<Theme.PageMeta> = {
    ...matter(fileContent).data
  }
  if (!meta.title) {
    meta.title = getDefaultTitle(fileContent)
  }
  if (!meta.date) {
    // getGitTimestamp(v).then((v) => {
    //   meta.date = formatDate(v)
    // })
    meta.date = getFileBirthTime(v)
  } else {
    // TODO: 开放配置，设置时区
    meta.date = formatDate(
      new Date(`${new Date(meta.date).toUTCString()}+8`)
    )
  }

  // 处理tags和categories,兼容历史文章
  meta.tag = (meta.tag || []).concat([
    ...new Set([...(meta.categories || []), ...(meta.tags || [])])
  ])

  // 获取摘要信息
  const wordCount = 100
  meta.description =
    meta.description || getTextSummary(fileContent, wordCount)

  // 获取封面图
  meta.cover =
    meta.cover ||
    fileContent.match(/[!]\[.*?\]\((https:\/\/.+)\)/)?.[1] ||
    ''
  return {
    route: `/${route}`,
    meta
  }
}
```

TODO: 第一个 if else 语句部分涉及到了 JS 正则表达式，按下不表，目的是处理 route，将其转变为可用的路径

然后使用 utf-8 格式打开这个文件，并赋值给 fileContent

之后定义 meta 变量，使用 gray-matter 提供的的 matter 来获取文件的 data 部分数据，这个变量的类型在之前已经引入了，是 Theme 下的一个接口，之后就是设置各种 meta 信息

TODO: 如何设置各种 meta 信息

最后返回页面路由，还有 meta 信息

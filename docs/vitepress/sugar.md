---
title: 阅读 sugar theme 的源代码
tag:
  - vitepress
description: 本站使用的主题就是 sugar，但是和我的目标不符合，所以希望阅读源码并修改，此处为第一步：阅读源码
---

# 阅读 sugar 源代码

## 构成

使用 tree 命令可以看到下面的目录结构

```
.
├── package.json
├── src
│   ├── components
│   │   ├── BlogAlert.vue
│   │   ├── BlogApp.vue
│   │   ├── BlogArticleAnalyze.vue
│   │   ├── BlogComment.vue
│   │   ├── BlogFriendLink.vue
│   │   ├── BlogHomeBanner.vue
│   │   ├── BlogHomeInfo.vue
│   │   ├── BlogHomeOverview.vue
│   │   ├── BlogHomeTags.vue
│   │   ├── BlogHotArticle.vue
│   │   ├── BlogImagePreview.vue
│   │   ├── BlogItem.vue
│   │   ├── BlogList.vue
│   │   ├── BlogPopover.vue
│   │   ├── BlogRecommendArticle.vue
│   │   ├── BlogSearch.vue
│   │   ├── BlogSidebar.vue
│   │   └── TimelinePage.vue
│   ├── composables
│   │   └── config
│   │       ├── blog.ts
│   │       └── index.ts
│   ├── index.ts
│   ├── node.ts
│   ├── styles
│   │   ├── bg.png
│   │   └── index.scss
│   └── utils
│       └── index.ts
├── tsconfig.json
└── types
    └── vue-shim.d.ts
```

首先阅读配置文件，阅读顺序是

1. package.json
2. tsconfig.json
3. types/vue-shim.d.ts

## package.json

:::info
以下信息来自

1. [npm 介绍](https://zhuanlan.zhihu.com/p/23311680)
2. [阮一峰 ES6 入门](https://es6.ruanyifeng.com/#docs/module-loader)
   :::

### 无关紧要的信息

```json
{
  "name": "@sugarat/theme",
  "version": "0.1.9",
  "description": "Vitepress 博客主题，sugarat vitepress blog theme",
  "author": "sugar",
  "license": "MIT",
  "homepage": "https://theme.sugarat.top",
  "bugs": {
    "url": "https://github.com/ATQQ/sugar-blog/issues"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/ATQQ/sugar-blog.git"
  },
  "keywords": ["vitepress", "theme", "粥里有勺糖"]
}
```

name 和 version 是 最重要的两个属性，唯一标识了一份 npm 模块

description 相当于模块的简介，方便其他人快速了解

author 和 license 如其名称

homepage: 表示项目主页

bug 是用来反馈你的模块 bug 的地方

repository 指定一个代码存放地址，对想要为你的项目贡献代码的人有帮助。像这样：

keywords 用来指示该仓库的关键字，方便搜索

### 代码结构信息

```json
{
  "main": "src/index.ts",
  "exports": {
    "./node": {
      "types": "./node.d.ts",
      "default": "./node.js"
    },
    ".": "./src/index.ts"
  },
  "files": ["src", "types", "node.js", "node.d.ts"]
}
```

main 属性指定了程序的主入口文件。require 时候将会从这个属性指定的目录加载文件

exports 属性是 node 新版本的一个新属性，用来指示模块的入口点，其优先级高于 main，而且支持定义别名，详情请见阮一峰博客。types 属性和 default 属性是 exports 字段的子属性，它们可以指定不同的模块解析方式。types 属性用于指定类型声明文件的路径，default 属性用于指定默认的模块路径。

files 属性的值是一个数组，内容是模块下文件名或者文件夹名，可以使用 `.npmignore` 排除，当你上传模块时会使用到

### 其他信息

```json
{
  "scripts": {
    "dev": "vitepress dev demo",
    "dev:lib": "npm run build:node && vitepress dev demo",
    "build": "npm run build:node && npm run build:docs",
    "build:docs": "vitepress build demo",
    "build:node": "npx tsup src/node.ts --dts --out-dir=./",
    "serve": "npm run build && vitepress serve demo"
  },
  "dependencies": {
    "@vue/shared": "^3.2.45",
    "@vueuse/core": "^9.6.0",
    "fast-glob": "^3.2.12",
    "gray-matter": "^4.0.3"
  },
  "devDependencies": {
    "@element-plus/icons-vue": "^2.0.10",
    "element-plus": "^2.2.28",
    "sass": "^1.56.1",
    "tsup": " ^6.5.0",
    "typescript": "^4.8.2",
    "vitepress": "1.0.0-alpha.46",
    "vue": "^3.2.45"
  },
  "pnpm": {
    "peerDependencyRules": {
      "ignoreMissing": ["@algolia/client-search"]
    }
  }
}
```

script 表示一些可以用来执行的脚本，相当于一个 alias

dependencies 表示使用此模块需要的依赖

devDependencies 表示开发此模块的人使用或者依赖的模块

pnpm 下的那一串属性表示 pnpm 不会打印有关依赖列表中缺少对 peerDependency 的警告。

## tsconfig.json

:::info
参考以下网站

1. [TS 中文教程](https://www.tslang.cn/docs/handbook/tsconfig-json.html)

:::

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@sugarat/theme/node": ["./node"],
      "@sugarat/theme": ["src/index.ts"]
    },
    "module": "esnext",
    "outDir": "dist",
    "target": "esnext",
    "moduleResolution": "node",
    "strict": true,
    "jsx": "preserve",
    "esModuleInterop": true,
    "noUnusedLocals": true,
    "lib": ["ESNext", "DOM"],
    "skipLibCheck": true,
    "allowJs": true,
    "resolveJsonModule": true
  },
  "include": [
    "src",
    "types",
    "demo/.vitepress/theme",
    "demo/.vitepress/config.ts"
  ],
  "exclude": ["node_modules", "dist", "node.d.ts"]
}
```

如果一个目录下存在一个 tsconfig.json 文件，那么它意味着这个目录是 TypeScript 项目的根目录。

baseUrl 和 paths 用来起一个别名，方便开发时引入模块，少用相对路径

include 选项默认包含当前目录和子目录下所有的 TypeScript 文件（.ts, .d.ts 和 .tsx）。
如果 allowJs 被设置成 true，JS 文件（.js 和.jsx）也被包含进来。
exclude 排除那些不需要编译的文件或文件夹。

"jsx"：指定 jsx 代码的生成，这些模式只在代码生成阶段起作用

## types/vue-shim.d.ts

一个类型定义文件，不知到从哪里搞来的，回来想办法看看

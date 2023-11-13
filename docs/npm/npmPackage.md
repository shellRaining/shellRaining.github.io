---
title: 发布一个 npm 包的流程
tag:
  - diary
description: 记录一下发布的过程
---

# {{ $frontmatter.title }}

本来这个博文在一周之前就能完成，但是因为编写全半角转换插件的问题，拖了很久，就趁着这个完工的时候，把这个小了结一下。

1. 首先新建一个什么乱七八糟的仓库，在其下使用命令 `npm init --scope=@xxx`，表示这个仓库的命名空间为个人用户名
1. 填写必要的 npm 包信息，包括个人信息，版本号和包名，起始路径等
1. 使用 `npm login` 先登录，然后使用 `npm pack` 检查打包后的包，如果有残留文件可以使用 `.npmignore` 文件来忽略
1. 使用 `npm link` 将这个包链接到全局，然后在其他项目中使用 `npm link @xxx/xxx` 来进行测试
1. 使用 `npm version ...` 来发布版本更新，最后 `npm publish --access public`

如果是 TypeScript 包的话，记得发布声明文件还有编译后的文件，最好还声明一个 `prepublish` 字段

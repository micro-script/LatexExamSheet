# Changelog

此处记载了项目中所有值得留意的改动。

格式参照 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
并且此项目遵守 [Semantic Versioning](https://semver.org/spec/v2.0.0.html)。

## [Unreleased]

## [0.1.7] - 2022-07-08

### Fixed

- 去掉 `.str_set:N` 使得模版兼容  TeXLive 2021 （#I5G7X2）

## [0.1.7] - 2022-07-07

### Added

- 增加 `exam-zh-symbols.sty` 模块绘制部分中国化的数学符号

### Changed

- 修改 `\complement` 的效果

### Fixed

- 修复 `a3paper` 的分数框问题（#I5FZWW）

## [0.1.7] - 2022-07-06

### Added

- 增加 `\fillin` 的 `width` 键值

## [0.1.6] - 2022-07-05

### Added

- `\fillin` 命令增加一个 `circle` 类型（#I5FMPP）

### Changed

- 将 `\paren` 和 `\fillin` 的答案控制单独分离


## [0.1.6] - 2022-07-04

### Added

- 增加 `\examsquare` 方格命令
- 增加 `step`、`method`、`case` 环境
- 增加页脚内容定制接口 `page/foot-content`

## [0.1.6] - 2022-07-03

### Added

- 增加标题的控制接口
- 增加顶部的个人信息接口
- 增加 `\warning` 命令
- 增加草稿纸 `\draftpaper` 以及相关接口

### Changed

- 将 `\goodluck` 命令改为参数式


## [0.1.5] - 2022-07-02

### Added

- 增加 `solution` 环境和 `score` 命令

## [0.1.4] - 2022-06-27

### Added

- 基本完成用户手册的编写

## [0.1.4] - 2022-06-24

### Added

- 给 `\fillin` 命令增加了可选参数接口
- `choices` 环境增加 `index` 接口

## [0.1.3] - 2022-06-22

### Added

- 增加密封线奇偶统一控制接口

### Fixed

- 修复密封线接口失效问题


## [0.1.2] - 2022-06-16

- 完成密封线的所有接口设计

## [0.1.2] - 2022-06-15

- 增加密封线


## [0.1.2] - 2022-06-14

### Added

- 新增页面尺寸 `a4paper` 和 `a3paper` 的控制
- 新增 `a3paper` 页面的“是否共用页脚”控制


## [0.1.1] - 2022-06-09

### Added

- 新增 `question` 环境的 `top-sep` 和 `bottom-sep` 选项控制前后距离（[#I4SLWN](https://gitee.com/zepinglee/exam-zh/issues/I4SLWN)）。
- 新增 `question` 环境的 `index` 选项设置题号（[#I4SQLI](https://gitee.com/zepinglee/exam-zh/issues/I4SQLI)）。
- 新增 `question` 环境的 `answer-color` 选项控制答案颜色（[#I4SW79](https://gitee.com/zepinglee/exam-zh/issues/I4SW79)）。
- 新增 `choices` 环境的 `label` 选项控制标签格式（[#I4SXC1](https://gitee.com/zepinglee/exam-zh/issues/I4SXC1)）。
- 新增 `\circlednumber` 使用中文字体生成带圈数字。
- 新增 `choices` 环境的 `label-align` 选项控制标签的对齐方式（[#I4TDSA](https://gitee.com/zepinglee/exam-zh/issues/I4TDSA)）。
- 新增 `exam-zh-font` 模块，提供西文字体 `font` 和数学字体 `math-font` 选项（[#I512EV](https://gitee.com/zepinglee/exam-zh/issues/I512EV)）。
- 新增 `fillin` 命令的 `type` 选项控制下划线和括号类型

### Fixed

- 答案的内容较高时调整深度（[#I4SXC1](https://gitee.com/zepinglee/exam-zh/issues/I4SXC1)）。

## [v0.1.0] - 2022-02-04

### Added

- 在 Gitee 发布。

[Unreleased]: https://gitee.com/zepinglee/exam-zh/compare/v0.1.0...HEAD
[v0.1.0]: https://gitee.com/zepinglee/exam-zh/releases/v0.1.0
[v0.1.1]: https://gitee.com/zepinglee/exam-zh/releases/v0.1.1

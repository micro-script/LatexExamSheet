# 高考数学试卷 LaTeX 模板

- 项目主页：<https://gitee.com/zepinglee/exam-zh>
- 作者：Zeping Lee
- 授权：[LaTeX Project Public License 1.3c](https://www.latex-project.org/lppl.txt)


本项目提供了一个中国高考数学试卷样式的 LaTeX 模板，旨在帮助中小学教师更方便地使用 LaTeX。模板具有以下特性：

1. 样式与内容尽可能分离；
2. 选择题选项可以自动排版成合适的列数；
3. 在 Windows, macOS 和 Linux 跨平台编译。

## 示例

```latex
\section{选择题：本题共 8 小题，每小题 5 分，共 40 分。}

\begin{question}
  设集合 $A = \{x \mid -1 < x < 4\}$，$B = \{2, 3, 4, 5\}$，则 $A \cap B = $ \paren
  \begin{choices}
    \item $\{2\}$
    \item $\{2, 3\}$
    \item $\{3, 4\}$
    \item $\{2, 3, 4\}$
  \end{choices}
\end{question}

\section{填空题：本题共 4 小题，每小题 5 分，共 20 分。}

\begin{question}
  已知函数 $f(x) = x^3 (a \cdot 2^x - 2^{-x})$ 是偶函数，则 $a = $ \fillin 。
\end{question}

\section{解答题：本题共 6 小题，共 70 分。解答应写出文字说明、证明过程或者演算步骤。}

\begin{problem}[points = 12]
  已知函数 $f(x) = x (1 - \ln x)$。讨论 $f(x)$ 的单调性。
  设 $a$，$b$ 为两个不相等的正数，且 $b \ln a - a \ln b = a - b$，
  证明：$2 < \frac{1}{a} + \frac{1}{b} < \eu$。
\end{problem}
```


## 使用方法

### 题目环境 `question` 和 `problem`

选择题和填空题使用 `question` 环境，解答题使用 `problem` 环境。两者的内容对齐方式不同。

`question` 和 `problem` 环境还接受一个可选参数，其中可以使用以下 key—value 进行设置。
- `answer-color` 答案的颜色（默认：`black`）。
- `index` 题号。
- `points` 题目的分数（默认：`0`）。
- `show-points` 是否显示选择题的括号（默认 `false`）。
- `show-points` 是否显示题目的分数（默认 `auto`：选择题和填空题默认 `false`，解答题默认 `true`）。
- `show-answer` 是否显示答案（默认：`false`）。
- `top-sep` 题目上方垂直方向的空白距离（默认：`.5em plus .5em minus .2em`）。
- `bottom-sep` 题目下方垂直方向的空白距离，与 `top-sep` 不叠加（默认：`.5em plus .5em minus .2em`）。

其中 `index`、`show-points`、`show-answer`、`top-sep` 和 `bottom-sep` 可以使用 `\examsetup` 命令的 `choices` 层级进行全局设置。比如设置同一层级的多个选项：
```latex
\examsetup{
  choices = {
    show-points = true,
    show-answer = true,
  },
}
```
也可以用斜线“/”表示层级并设置单项。
```latex
\examsetup{
  question/show-points = true,
  question/show-answer = true,
}
```


### 选择题的括号 `\paren` 和填空 `\fillin`

`\paren` 和 `\fillin` 命令分别生成选择题的括号和填空题的横线。这两个命令还分别接受一个可选参数作为题目的答案，当 `show-answer = true` 时则将答案显示在其中。



### 选项环境 `choices`

选择题的选项使用 `choices` 环境排版，可以自动根据内容的长度选择合适的列数并对齐。该环境的设计主要参考了 @xkwxdyy 的 [choices-l3](https://gitee.com/xkwxdyy/choices-l3) 和 [xchoices](https://gitee.com/xkwxdyy/xchoices) 项目。
```latex
\begin{choices}[label-pos = top-left]
  \item $\{2\}$
  \item $\{2, 3\}$
  \item $\{3, 4\}$
  \item $\{2, 3, 4\}$
\end{choices}
```
其中的可选参数使用 key–value 的方式进行设置，除了 `label-pos` 外还包括以下选项。
- `column-sep` （默认 `1em`） 选项列之间的最小间隔。
- `columns`    （默认 `0`）   强制按照该列数排版选项，如果为 0 则自动选择合适的列数。
<!-- - `label-align`（可选：`left`, `center`, `right`；默认 `right`）标签内容的对齐方式。 -->
- `label-pos`  （可选：`auto`, `top-left`, `left`, `bottom`；默认 `auto`）标签相对于选项内容的位置；`auto` 表示自动选择：如果内容高度超过两行时（通常是图片）标签位于左居中 `left`，否则位于左上角跟首行文字对齐（`top-left`）。
- `label-sep`  （默认 `0.5em`）标签与选项之间的距离。
- `label-width`（默认 `0pt`）标签的宽度；如果宽度不足会自动调整为最长标签的宽度。
- `max-columns`（默认 `4`）选项的最大列数；排版选项时会优先尝试该列数，如果无法排下内容，依次将列数除以 2 并取整再进行尝试，直到可以排下全部选项。

这些选项可以使用 `\examsetup` 命令的 `choices` 层级进行全局设置，类似 `question`。



### 正体的数学常数

按照国标，数学常数应使用正体。模板中提供了命令 `\eu` 和 `\iu` 分别表示自然对数的底“e”和虚数单位“i”。`\eu` 可以理解为 “e upright” 的缩写或者 “Euler‘s number” 的首字母，`\iu` 可以理解为 “i upright” 或 “imaginary unit” 的缩写，这样更方便记忆。圆周率“π”直接使用 `\uppi` 命令。



## 待完成

- [ ] 题干与图片的排版（参考 [xkwxdyy/text-figure](https://gitee.com/xkwxdyy/text-figure)）



## 反馈

欢迎反馈项目的问题或者改进建议。推荐使用发 issue 的形式，并且附上相关的代码和截图。



## 使用授权

本项目以 LaTeX Project Public License v1.3 协议发布。




## 相关项目

- Philip Hirschhorn, `exam`: <https://www.ctan.org/pkg/exam>
- 鲍宏昌 `BHCexam`: <https://github.com/mathedu4all/bhcexam>
- 吕荐瑞 `jnuexam`: <https://www.ctan.org/pkg/jnuexam>
- @htharoldht `USTBExam`: <https://github.com/htharoldht/USTBExam>
- 唐绍东 `GEEexam`: <https://github.com/shaodongtang/gaokao_exam>
- 唐绍东 `CMC`: <https://github.com/shaodongtang/CMC>
- @sd44 `DANexam`: <https://github.com/sd44/DANexam>
- 胡振震 `simplexam`: <https://github.com/hushidong/simplexam>

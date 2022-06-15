%
% Copyright (c) 2022 Zeping Lee
% Released under the LaTeX Project Public License v1.3c License.
% Repository: https://gitee.com/zepinglee/exam-zh
%

\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\RequirePackage{expl3}
\ProvidesExplClass {exam-zh} {2022-06-14} {v0.1.2} {LaTeX template for Chinese exam}

% 检查 LaTeX2e kernel 版本
\msg_new:nnn { exam-zh } { latex-too-old }
  { TeX~ Live~ 2020~ or~ later~ version~ is~ required~ to~ compile~ this~ document. }
\@ifl@t@r \fmtversion { 2020/02/02 }
  { }
  { \msg_fatal:nn { exam-zh } { latex-too-old } }

% 检查编译引擎，要求使用 XeLaTeX。
\msg_new:nnn { exam-zh } { incompatible-engine }
  { XeLaTeX~ is~ required~ to~ compile~ this~ document. }

\sys_if_engine_xetex:F
  { \msg_fatal:nn { exam-zh } { incompatible-engine } }


% 使用 l3keys 定义 \examsetup 配置命令
\NewDocumentCommand \examsetup { m }
  { \keys_set:nn { exam-zh } {#1} }




% 加载文档类和宏包

% 处理文档类选项
\PassOptionsToClass { UTF8 , scheme = chinese } { ctexart }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { ctexart } }
\ProcessOptions*

\RequirePackage { filehook }
\AtEndOfPackageFile* { fontspec }
  { \msg_redirect_name:nnn { fontspec } { no-script } { none } }
\AtEndOfPackageFile* { xeCJK }
  {
    \msg_redirect_name:nnn { xeCJK } { CJKfamily-redef } { none }
    \defaultCJKfontfeatures
      {
        Script  = CJK,
        Mapping = fullwidth-stop ,
      }
  }

% 载入 \cls{ctexart} 文档类。
\LoadClass { ctexart }

% 要求 ctex v2.4.9 2017-04-01 或更高的版本。
\msg_new:nnn { exam-zh } { require-package-version }
  { The~ package~ "#1"~ is~ required. }

\@ifclasslater { ctexart } { 2017/04/01 }
  { }
  {
    \msg_fatal:nnn { exam-zh } { require-package-version }
      { ctex~ v2.4.9~ 2017-04-01 }
  }

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
\RequirePackage { etoolbox }
\RequirePackage { geometry }
\RequirePackage { fontspec }
\RequirePackage { xeCJK }
\RequirePackage { xeCJKfntef }
\RequirePackage { fancyhdr }
\RequirePackage { lastpage }
\RequirePackage { amsmath }
\RequirePackage { enumitem }

\ExplSyntaxOff
\RequirePackage { tikzpagenodes }
\usetikzlibrary { decorations.markings }
\usetikzlibrary { decorations.text }
\ExplSyntaxOn

\RequirePackage { exam-zh-font }
\RequirePackage { exam-zh-question }
\RequirePackage { exam-zh-choices }



% 对冲突的宏包报错。
\msg_new:nnn { exam-zh } { package-conflict }
  { The~ "#2"~ package~ is~ incompatible~ with~ "#1". }

\cs_new:Npn \examzh_package_conflict:nn #1#2
  {
    \AtEndOfPackageFile* {#1}
      {
        \AtBeginOfPackageFile* {#2}
          { \msg_error:nnnn { exam-zh } { package-conflict } {#1} {#2} }
      }
  }

\examzh_package_conflict:nn { unicode-math } { amscd }
\examzh_package_conflict:nn { unicode-math } { amsfonts }
\examzh_package_conflict:nn { unicode-math } { amssymb }
\examzh_package_conflict:nn { unicode-math } { bbm }
\examzh_package_conflict:nn { unicode-math } { bm }
\examzh_package_conflict:nn { unicode-math } { eucal }
\examzh_package_conflict:nn { unicode-math } { eufrak }
\examzh_package_conflict:nn { unicode-math } { mathrsfs }
\examzh_package_conflict:nn { unicode-math } { newtxmath }
\examzh_package_conflict:nn { unicode-math } { upgreek }

\examzh_package_conflict:nn { enumitem } { paralist }


% 纸张和页面布局

% 控制 a3paper 和 a4paper
\bool_new:c { g__examzh_page_style_a4paper_bool }
% a3paper 的页脚：两页共用一个或者仍然一页一个
\bool_new:c { g__examzh_page_a3paper_foot_common_bool }

\keys_define:nn { exam-zh / page }
  {
    % 页面大小
    style .choice:,
    style / a3paper .code:n =
      {
        \bool_gset_false:c { g__examzh_page_style_a4paper_bool }
      },
    style / a4paper .code:n =
      {
        \bool_gset_true:c { g__examzh_page_style_a4paper_bool }
      },
    style .value_required:n = true,
    % 页脚的类型
    foot-style .choice:,
    foot-style / common .code:n =
      {
        \bool_gset_true:c 
          { g__examzh_page_a3paper_foot_common_bool }
      },
    foot-style / separate .code:n =
      {
        \bool_gset_false:c 
          { g__examzh_page_a3paper_foot_common_bool }
      }
  }
\keys_set:nn { exam-zh / page }
  {
    style = a4paper,
    foot-style = common,
  }

\keys_define:nn { exam-zh }
  {
    page .meta:nn = { exam-zh / page } {#1} 
  }


% 字体

% 中文字体

% 在 ctex 的字体配置的基础上进行一些修改
% 将苹方和微软雅黑分别替换为华文黑体和中易黑体
\str_if_eq:onTF { \g__ctex_fontset_tl } { mac }
  {
    \setCJKsansfont { Heiti~ SC~ Light } [ BoldFont = Heiti~ SC~ Medium ]
  }
  {
    \str_if_eq:onT { \g__ctex_fontset_tl } { windows }
      { \setCJKsansfont { SimHei } }
  }

% 罗马数字使用中文字体
\xeCJKDeclareCharClass { CJK } { "2160 -> "217F }
% 带圈数字
\xeCJKDeclareCharClass { CJK } { "2460 -> "2473 }


% 如果有内容较高（如分式）使得行间距小于 0.5em，则将其增加至 0.5em。
\dim_set:Nn \lineskiplimit { .5em }
\skip_set:Nn \lineskip { .5em }



% 设置 enumitem 列表格式
\setlist{nosep}

\setlist[enumerate, 2]{
  left       = 2em,
  labelsep   = 0pt,
  label = { （ \arabic * ） }
}



% 科目
\tl_new:N \l__exam_zh_subject_tl
\NewDocumentCommand \subject { m }
  { \tl_set:Nn \l__exam_zh_subject_tl {#1} }

% 修改标题的格式
\cs_set:Npn \@maketitle
  {
    \newpage
    % \null
    % \vskip 2em
    \secret \par
    \begin { center }
      \let \footnote \thanks
      { \Large \@title \par }
      \vskip 1.5em
      { \sffamily \bfseries \huge \l__exam_zh_subject_tl }
    \end { center }
    \par
    \vskip 0.5em
  }


\prg_new_conditional:Npnn \examzh_if_defined:N #1 { T , F , TF }
  {
    \if_meaning:w #1 \@undefined
      \prg_return_false:
    \else:
      \prg_return_true:
    \fi:
  }

\NewDocumentCommand \secret { }
  {
    绝密 $\bigstar$ 启用前
  }
% 祝考试顺利
\NewDocumentCommand \goodluck { }
  {
    \group_begin:
      \centering
      \examzh_if_defined:NTF \lishu
        { \lishu }
        { \bfseries }
      \Large
      $\bigstar$ 祝考试顺利 $\bigstar$
      \par
    \group_end:
  }


% 注意事项环境 notice
\NewDocumentEnvironment { notice } { O { } }
  {
    \noindent
    \group_begin:
      \sffamily \bfseries
      注意事项：
    \group_end:
    \begin { enumerate }
      [
        leftmargin = 0pt ,
        itemindent = 3.5em ,
        labelsep   = 0.5em ,
        labelwidth = 1.5em ,
        align      = right ,
        label      = { \arabic * . } ,
        #1
      ]
  }
  {
    \end { enumerate }
  }


% 大题的标题使用 \ctexset 设置 \section 的格式

\ctexset
  {
    section =
      {
        format    = \heiti \bfseries ,
        number    = \chinese { section } ,
        aftername = { 、 } ,
      }
  }


% 正体的 e 和 i
\NewDocumentCommand \eu { } { \mathrm{ e } }
\NewDocumentCommand \iu { } { \mathrm{ i } }


% 兼容 siunitx v2.x 的一些命令
\AtEndOfPackageFile* { siunitx }
  {
    \ProvideDocumentCommand \unit       { } { \si }
    \ProvideDocumentCommand \qty        { } { \SI }
    \ProvideDocumentCommand \qtyproduct { } { \SI }
  }



% 密封线
\bool_new:N \g__examzh_sealline_show_bool

\keys_define:nn { exam-zh / sealline }
  {
    show-sealline .bool_gset:N = \g__examzh_sealline_show_bool
  }
\keys_set:nn { exam-zh / sealline }
  {
    show-sealline = true
  }
\keys_define:nn { exam-zh }
  { sealline .meta:nn = { exam-zh / sealline } {#1} }


% 用于处理页码实现密封线的 a4 和 a3 奇偶统一处理
\int_new:N \l__examzh_sealline_page_number_int

\AtEndPreamble
  {
    \bool_if:NT \g__examzh_sealline_show_bool
      {
        \AddToHook { shipout / background }
          {
            \bool_if:cTF { g__examzh_page_style_a4paper_bool }
              {
                \int_set:Nn \l__examzh_sealline_page_number_int
                  { \c@page }
              }
              {
                \int_set:Nn \l__examzh_sealline_page_number_int
                  { \c@page / 2 }
              }
            \put (0cm, 0cm)
              {
                \int_if_odd:nTF { \l__examzh_sealline_page_number_int }
                  {
                    \__examzh_sealline_odd:
                  }
                  {
                    \__examzh_sealline_even:
                  }
              }
          }
      }
  }
\AtEndPreamble
  {
    \bool_if:cTF { g__examzh_page_style_a4paper_bool }
      {
        % a4paper
        \bool_if:NTF \g__examzh_sealline_show_bool
          {
            % 有密封线
            \geometry
              {
                twoside,
                paper  = a4paper,
                margin = 1in,
                inner  = 1.3in,
                outer  = 0.8in,
              }
          }
          {
            % 无密封线
            \geometry
              {
                paper  = a4paper,
                margin = 1in,
              }
          }
      }
      {
        % a3paper
        \bool_if:NTF \g__examzh_sealline_show_bool
          {
            % 有密封线
            \geometry
              {
                twoside,
                paper      = a3paper,
                landscape,
                twocolumn,
                columnsep  = 30mm,
                margin     = 1in,
                outer      = 1.5in,
                inner      = 0.5in,
                % showframe
              }
          }
          {
            % 无密封线
            \geometry
              {
                paper      = a3paper,
                landscape,
                twocolumn,
                columnsep  = 30mm,
                margin     = 1in,
              }
          }
      }
  }


\cs_new:Npn \__examzh_sealline_odd:
  {
    \begin{tikzpicture}
      [
        remember~picture,
        overlay,
        every~node/.style = {fill = white},
        % transform~shape
      ]
      % 密封线：线
      \__examzh_sealline_odd_line:
      % 密封线：小圆圈
      \__examzh_sealline_odd_circle:
      % 线上的文字
      \__examzh_sealline_odd_text_around_line:
    \end{tikzpicture}
  }

\cs_new:Npn \__examzh_sealline_even:
  {
    \begin{tikzpicture}[remember~picture, overlay]
      % 密封线：线
      \__examzh_sealline_even_line:
      % 密封线：小圆圈
      \__examzh_sealline_even_circle:
      % 线上的文字
      \__examzh_sealline_even_text_around_line:
    \end{tikzpicture}
  }

% 虚线
\cs_new:Npn \__examzh_sealline_odd_line:
  {
    \draw
      [
        line~width   = 2.7pt,
        line~cap     = round,
        dash~pattern = 0n~0pt~off~9pt
      ]
      ([xshift = -8mm]current~page~text~area.north~west)
        --
      ([xshift = -8mm]current~page~text~area.south~west);
  }
\cs_new:Npn \__examzh_sealline_even_line:
  {
    \draw 
      [
        line~width    = 2.7pt,
        line~cap      = round,
        dash~pattern  = 0n~0pt~off~9pt
      ] 
      ([xshift = 8mm]current~page~text~area.north~east)
        --
      ([xshift = 8mm]current~page~text~area.south~east);
  }

% 小圆圈
\cs_new:Npn \__examzh_sealline_odd_circle:
  {
    \fill
      [
        decorate,
        decoration =
          {
            markings,
            mark = between~positions~0.07~and~0.98~step~3.5cm~with
              {
                \node [circle, draw = black, fill = white] {};
              }
          }
      ]
      ([xshift = -8mm]current~page~text~area.north~west)
        --
      ([xshift = -8mm]current~page~text~area.south~west);
  }
\cs_new:Npn \__examzh_sealline_even_circle:
  {
    \fill
      [
        decorate,
        decoration =
          {
            markings,
            mark = between~positions~0.04~and~0.98~step~4cm~with
              {
                \node [circle, draw = black, fill = white] {};
              }
          }
      ] 
      ([xshift = 8mm]current~page~text~area.north~east)
        --
      ([xshift = 8mm]current~page~text~area.south~east);
  }
% 线上的文字（密封线外不得答题）
\cs_new:Npn \__examzh_sealline_odd_text_around_line:
  {
    \path
      [
        decorate,
        decoration =
          {
            text~along~path,
            reverse~path,
            text~align = fit~to~path,
            text       = {密封线内不得答题}
          }
      ]
      ([xshift = -10mm, yshift = -30mm]current~page~text~area.north~west)
        --
      ([xshift = -10mm, yshift = 30mm]current~page~text~area.south~west);
  }
\cs_new:Npn \__examzh_sealline_even_text_around_line:
  {
    \path
      [
        decorate,
        decoration =
          {
            text~along~path,
            text~align = fit~to~path,
            text = {密封线内不得答题}
          }
      ]
      ([xshift = 10mm, yshift = -30mm]current~page~text~area.north~east)
        --
      ([xshift = 10mm, yshift = 30mm]current~page~text~area.south~east);
  }



% 页眉和页脚

\tl_set:Nn \headrulewidth { 0pt }
\cs_set_eq:NN \@mkboth \use_none:n
\cs_set_eq:NN \sectionmark \use_none:n
\cs_set_eq:NN \subsectionmark \use_none:n

\cs_new:Npn \__examzh_column_box:n #1
  {
    \makebox [ \columnwidth ] {#1}
  }


\fancypagestyle { plain }
  {
    \fancyhf { }
    \bool_if:cTF { g__examzh_page_style_a4paper_bool }
      {
        % a4paper
        \fancyfoot [ C ]
          {
            \small
            数学试题第 \thepage { } 页（共 \pageref { LastPage } ~ 页）
          }
      }
      {
        % a3paper
        \bool_if:cTF 
          { g__examzh_page_a3paper_foot_common_bool }
          {
            % 两页共用一个页脚
            \fancyfoot [ C ]
              {
                \small
                数学试题第 \thepage { } 页（共 \pageref { LastPage } ~ 页）
              }
          }
          {
            % 每页一个页脚
            \fancyfoot [ L ]
              {
                \__examzh_column_box:n
                  {
                    \small
                    数学试题第 \thepage { } 页（共 \pageref { LastPage } ~ 页）
                  }
              }
            \fancyfoot [ R ]
              {
                \__examzh_column_box:n
                  {
                    \int_gincr:N \c@page
                    \small
                    数学试题第 \thepage { } 页（共 \pageref { LastPage } ~ 页）
                  }
              }
          }
      }
  }
\AtEndPreamble { \pagestyle { plain } }
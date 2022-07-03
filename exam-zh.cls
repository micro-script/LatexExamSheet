%
% Copyright (c) 2022 Zeping Lee
% Released under the LaTeX Project Public License v1.3c License.
% Repository: https://gitee.com/zepinglee/exam-zh
%

\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\RequirePackage{expl3}
\ProvidesExplClass {exam-zh} {2022-07-03} {v0.1.6} {LaTeX template for Chinese exam}
\RequirePackage{ xtemplate }

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
\bool_new:c { g__examzh_page_size_a4paper_bool }
% a3paper 的页脚：两页共用一个或者仍然一页一个
\bool_new:c { g__examzh_page_a3paper_foot_common_bool }

\keys_define:nn { exam-zh / page }
  {
    % 页面大小
    size .choice:,
    size / a3paper .code:n =
      {
        \bool_gset_false:c { g__examzh_page_size_a4paper_bool }
      },
    size / a4paper .code:n =
      {
        \bool_gset_true:c { g__examzh_page_size_a4paper_bool }
      },
    size .value_required:n = true,
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
    size = a4paper,
    foot-style = separate,
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


% 横向的个人信息

\clist_new:N \l__examzh_horizontal_information_clist

\NewDocumentCommand \information { O{\quad} m }
% #1 分隔符
% #2 信息内容
  {
    \clist_set:Nn \l__examzh_horizontal_information_clist {#2}
    \__examzh_print_horizontal_information:n {#1}
  }
\cs_new:Npn \__examzh_print_horizontal_information:n #1
  {
    \par \null \hfill
    \clist_use:Nn \l__examzh_horizontal_information_clist {#1}
    \hfill \null \par
  }

% 警告，如“在此卷上答题无效”
\NewDocumentCommand \warning { O{\large \sffamily \bfseries} m }
  {
    \group_begin:
      #1
      \hfill #2 \hfill \null
    \group_end:
    \par
  }


% 标题处理
\keys_define:nn { exam-zh / title }
  {
    title-format .tl_set:N = \l__examzh_title_format_tl,
    subject-format .tl_set:N = \l__examzh_subject_format_tl,
    top-sep .skip_set:N = \l__examzh_title_top_sep_skip,
    bottom-sep .skip_set:N = \l__examzh_title_bottom_sep_skip,
  }
\keys_set:nn { exam-zh / title }
  {
    title-format   = \Large,
    subject-format = \sffamily \bfseries \huge,
    top-sep        = 0.5em plus 0.3em minus 0.2em,
    bottom-sep     = 0.5em plus 0.3em minus 0.2em,
  }
\keys_define:nn { exam-zh }
  { title .meta:nn = { exam-zh / title } {#1} }

% 科目
\tl_new:N \l__exam_zh_subject_tl
\NewDocumentCommand \subject { m }
  { \tl_set:Nn \l__exam_zh_subject_tl {#1} }

% 输出标题
\RenewDocumentCommand \maketitle { }
  {
    \par
    \addvspace { \l__examzh_title_top_sep_skip }
    \begin { center }
      \let \footnote \thanks
      { \l__examzh_title_format_tl \@title \par }
      \tl_if_blank:VF \l__exam_zh_subject_tl
        {
          \addvspace { 1em }
          { \l__examzh_subject_format_tl \l__exam_zh_subject_tl }
        }
    \end { center }
    \par
    \addvspace { \l__examzh_title_bottom_sep_skip }
  }



\prg_new_conditional:Npnn \examzh_if_defined:N #1 { T , F , TF }
  {
    \if_meaning:w #1 \@undefined
      \prg_return_false:
    \else:
      \prg_return_true:
    \fi:
  }

% 绝密 启用前
\NewDocumentCommand \secret { O{\bfseries} }
  {
    \par \noindent
    \group_begin:
      #1
      绝密 $\bigstar$ 启用前
    \group_end:
    \par
  }

% 祝考试顺利
\NewDocumentCommand \goodluck { O{祝考试顺利} }
  {
    \group_begin:
      \centering
      \examzh_if_defined:NTF \lishu
        { \lishu }
        { \bfseries }
      \Large
      $\bigstar$ #1 $\bigstar$
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

\keys_define:nn { exam-zh / sealline }
  {
    % 是否显示密封线
    show .bool_gset:N = \g__examzh_sealline_show_bool,
    % 密封线类型（也理解为出现的类型，比如只在第一页，只在奇数页）
    % scope .choice:,
    % scope / firstpage .code:n =
    %   { \__examzh_sealline_scope_firstpage: },
    % scope / oddpage .code:n =
    %   { \__examzh_sealline_scope_oddpage: },
    % scope / everypage .code:n =
    %   { \__examzh_sealline_scope_everypage: },
    scope .code:n = 
      {
        \str_gset:Nn \g__examzh_sealline_scope_str {#1}
      },
    % 线的厚度
    odd-line-thickness .dim_set:N = \g__examzh_sealline_odd_line_thickness_dim,
    even-line-thickness .dim_set:N = \g__examzh_sealline_even_line_thickness_dim,
    line-thickness .code:n =
      {
        \dim_set:Nn \g__examzh_sealline_odd_line_thickness_dim {#1}
        \dim_set:Nn \g__examzh_sealline_even_line_thickness_dim {#1}
      },
    % 线的偏移
    odd-line-xshift .dim_set:N = \g__examzh_sealline_odd_line_xshift_dim,
    odd-line-yshift .dim_set:N = \g__examzh_sealline_odd_line_yshift_dim,
    even-line-xshift .dim_set:N = \g__examzh_sealline_even_line_xshift_dim,
    even-line-yshift .dim_set:N = \g__examzh_sealline_even_line_yshift_dim,
    line-xshift .code:n =
      {
        \dim_gset:Nn \g__examzh_sealline_odd_line_xshift_dim {#1}
        \dim_gset:Nn \g__examzh_sealline_even_line_xshift_dim {#1}
      },
    line-yshift .code:n =
      {
        \dim_set:Nn \g__examzh_sealline_odd_line_yshift_dim {#1}
        \dim_set:Nn \g__examzh_sealline_even_line_yshift_dim {#1}
      },
    % 密封线的线类型
    odd-line-type .str_set:N = \g__examzh_sealline_odd_type_str,
    even-line-type .str_set:N = \g__examzh_sealline_even_type_str,
    line-type .code:n = 
      {
        \str_gset:Nn \g__examzh_sealline_odd_type_str {#1}
        \str_gset:Nn \g__examzh_sealline_even_type_str {#1}
      },
    % 密封线路径的文字内容
    odd-text .tl_set:N = \g__examzh_sealline_odd_text_tl,
    even-text .tl_set:N = \g__examzh_sealline_even_text_tl,
    text .code:n = 
      {
        \tl_gset:Nn \g__examzh_sealline_odd_text_tl {#1}
        \tl_gset:Nn \g__examzh_sealline_even_text_tl {#1}
      },
    % 密封线路径的文字内容偏移
    odd-text-xshift .dim_set:N = \g__examzh_sealline_odd_text_xshift_dim,
    even-text-xshift .dim_set:N = \g__examzh_sealline_even_text_xshift_dim,
    odd-text-yshift .dim_set:N = \g__examzh_sealline_odd_text_yshift_dim,
    even-text-yshift .dim_set:N = \g__examzh_sealline_even_text_yshift_dim,
    text-xshift .code:n = 
      {
        \dim_gset:Nn \g__examzh_sealline_odd_text_xshift_dim {#1}
        \dim_gset:Nn \g__examzh_sealline_even_text_xshift_dim {#1}
      },
    text-yshift .code:n = 
      {
        \dim_gset:Nn \g__examzh_sealline_odd_text_yshift_dim {#1}
        \dim_gset:Nn \g__examzh_sealline_even_text_yshift_dim {#1}
      },
    % 密封线上圆圈的参数
    % --控制显示--
    odd-circle-show .bool_set:N = \g__examzh_sealline_odd_circle_show_bool,
    even-circle-show .bool_set:N = \g__examzh_sealline_even_circle_show_bool,
    circle-show .choice:,
    circle-show / true .code:n =
      {
        \bool_gset_true:N \g__examzh_sealline_odd_circle_show_bool
        \bool_gset_true:N \g__examzh_sealline_even_circle_show_bool
      },
    circle-show / false .code:n =
      {
        \bool_gset_false:N \g__examzh_sealline_odd_circle_show_bool
        \bool_gset_false:N \g__examzh_sealline_even_circle_show_bool
      },
    % --开始--
    odd-circle-start .fp_set:N = \g__examzh_sealline_odd_circle_start_fp,
    even-circle-start .fp_set:N = \g__examzh_sealline_even_circle_start_fp,
    circle-start .code:n = 
      {
        \fp_gset:Nn \g__examzh_sealline_odd_circle_start_fp {#1}
        \fp_gset:Nn \g__examzh_sealline_even_circle_start_fp {#1}
      },
    % --结束--
    odd-circle-end .fp_set:N = \g__examzh_sealline_odd_circle_end_fp,
    even-circle-end .fp_set:N = \g__examzh_sealline_even_circle_end_fp,
    circle-end .code:n = 
      {
        \fp_gset:Nn \g__examzh_sealline_odd_circle_end_fp {#1}
        \fp_gset:Nn \g__examzh_sealline_even_circle_end_fp {#1}
      },
    % --步长--
    odd-circle-step .dim_set:N = \g__examzh_sealline_odd_circle_step_dim,
    even-circle-step .dim_set:N = \g__examzh_sealline_even_circle_step_dim,
    circle-step .code:n = 
      {
        \dim_gset:Nn \g__examzh_sealline_odd_circle_step_dim {#1}
        \dim_gset:Nn \g__examzh_sealline_even_circle_step_dim {#1}
      },
    % --直径--
    odd-circle-diameter .dim_set:N = \g__examzh_sealline_odd_circle_diameter_dim,
    even-circle-diameter .dim_set:N = \g__examzh_sealline_even_circle_diameter_dim,
    circle-diameter .code:n = 
      {
        \dim_gset:Nn \g__examzh_sealline_odd_circle_diameter_dim {#1}
        \dim_gset:Nn \g__examzh_sealline_even_circle_diameter_dim {#1}
      },
    % --偏移--
    odd-circle-xshift .dim_set:N = \g__examzh_sealline_odd_circle_xshift_dim,
    even-circle-xshift .dim_set:N = \g__examzh_sealline_even_circle_xshift_dim,
    circle-xshift .code:n = 
      {
        \dim_gset:Nn \g__examzh_sealline_odd_circle_xshift_dim {#1}
        \dim_gset:Nn \g__examzh_sealline_even_circle_xshift_dim {#1}
      },
    % 学生信息
    % --内容--
    odd-info-content .clist_set:N = \g__examzh_sealline_odd_info_content_clist,
    % --分隔符--
    odd-info-seperator .tl_set:N = \g__examzh_sealline_odd_info_seperator_tl,
    % --对齐--
    odd-info-align .tl_set:N = \g__examzh_sealline_odd_info_align_tl,
    % --偏移--
    odd-info-xshift .dim_set:N = \g__examzh_sealline_odd_info_xshift_dim,
    odd-info-yshift .dim_set:N = \g__examzh_sealline_odd_info_yshift_dim,
  }
\keys_set:nn { exam-zh / sealline }
  {
    show        = false,
    % scope      = firstpage,
    % scope      = oddpage,
    scope        = everypage,
    line-thickness       = 1pt,
    line-xshift          = 8mm,
    line-yshift          = 0mm,
    line-type            = loosely-dashed,
    text                 = 密封线内不得答题,
    text-xshift          = 11mm,
    text-yshift          = 30mm,
    circle-show          = true,
    circle-start         = 0.07,
    circle-end           = 0.92,
    circle-step          = 3.5em,
    circle-diameter      = 3mm,
    circle-xshift        = 8mm,
    odd-info-content     = {
      {\kaishu 姓名}：{\underline{\hspace*{8em}}},
      {\kaishu 准考证号}：{\underline{\hspace*{8em}}},
      {\kaishu 考场号}：{\underline{\hspace*{8em}}},
      {\kaishu 座位号}：{\underline{\hspace*{8em}}}
    },
    odd-info-seperator   = \hspace*{3em},
    odd-info-align       = center,
    odd-info-xshift      = 20mm,
    odd-info-yshift      = 0mm
  }
% \keys_set:nn { exam-zh / sealline }
%   {
%     show-sealline        = true,
%     % sealline-scope      = firstpage,
%     % sealline-scope      = oddpage,
%     sealline-scope        = everypage,
%     odd-line-thickness   = 2pt,
%     even-line-thickness  = 2pt,
%     odd-line-xshift      = 8mm,
%     odd-line-yshift      = 0mm,
%     even-line-xshift     = 8mm,
%     even-line-yshift     = 0mm,
%     odd-line-type        = loosely-dotted,
%     even-line-type       = loosely-dotted,
%     odd-text             = 密封线内不得答题,
%     even-text            = 密封线内不得答题,
%     odd-text-xshift      = 11mm,
%     even-text-xshift     = 11mm,
%     odd-text-yshift      = 30mm,
%     even-text-yshift     = 30mm,
%     odd-circle-show      = true,
%     even-circle-show     = true,
%     odd-circle-start     = 0.07,
%     even-circle-start    = 0.07,
%     odd-circle-end       = 0.98,
%     even-circle-end      = 0.98,
%     odd-circle-step      = 3.5em,
%     even-circle-step     = 3.5em,
%     odd-circle-diameter  = 3mm,
%     even-circle-diameter = 3mm,
%     odd-circle-xshift    = 8mm,
%     even-circle-xshift   = 8mm,
%     odd-info-content     = {
%       {\kaishu 学校}：{\underline{\hspace*{10em}}},
%       {\kaishu 班级}：{\underline{\hspace*{8em}}},
%       {\kaishu 姓名}：{\underline{\hspace*{8em}}},
%     },
%     odd-info-seperator   = \hspace*{3em},
%     odd-info-align       = center,
%     odd-info-xshift      = 20mm
%   }
\keys_define:nn { exam-zh }
  { sealline .meta:nn = { exam-zh / sealline } {#1} }

% 只在第一页出现
\cs_new:Npn \__examzh_sealline_scope_firstpage:
  {
    \AddToHook { shipout / firstpage }
      {
        \put (0cm, 0cm)
          { \__examzh_sealline_odd: }
      }
  }
% 只在奇数页出现
\cs_new:Npn \__examzh_sealline_scope_oddpage:
  {
    \AddToHook { shipout / background }
      {
        \put (0cm, 0cm)
          {
            \int_if_odd:nT { \c@page }
              { \__examzh_sealline_odd: }
          }
      }
  }
% 每页都有，奇偶不同
\cs_new:Npn \__examzh_sealline_scope_everypage:
  {
    \AddToHook { shipout / background }
      {
        \put (0cm, 0cm)
          {
            \int_if_odd:nTF { \c@page }
              { \__examzh_sealline_odd: }
              { \__examzh_sealline_even: }
          }
      }
  }

\AtEndPreamble
  {
    \bool_if:NT \g__examzh_sealline_show_bool
      {
        \__examzh_sealline_scope_set:
        \str_case:Vn \g__examzh_sealline_scope_str
          {
            { firstpage } { \__examzh_sealline_scope_firstpage: }
            { oddpage   } { \__examzh_sealline_scope_oddpage:   }
            { everypage } { \__examzh_sealline_scope_everypage: }
          }
      }
  }
\cs_new:Npn \__examzh_sealline_scope_set:
  {
    \tl_gset:Nx \g__examzh_sealline_odd_type_parameter_tl
      {
        \str_case:Vn \g__examzh_sealline_odd_type_str
          {
            { solid }  { solid }
            { dotted } { dotted }
            { densely-dotted } { densely~dotted }
            { loosely-dotted } { loosely~dotted }
            { dashed } { dashed }
            { densely-dashed } { densely~dashed }
            { loosely-dashed } { loosely~dashed }
            { dash-dot } { dash~dot }
            { densely-dash-dot } { densely~dash~dot }
            { loosely-dash-dot } { loosely~dash~dot }
            { dash-dot-dot } { dash~dot~dot }
            { densely-dash-dot-dot } { densely~dash~dot~dot }
            { loosely-dash-dot-dot } { loosely~dash~dot~dot }
          }
      }
    \tl_gset:Nx \g__examzh_sealline_even_type_parameter_tl
      {
        \str_case:Vn \g__examzh_sealline_even_type_str
          {
            { solid }  { solid }
            { dotted } { dotted }
            { densely-dotted } { densely~dotted }
            { loosely-dotted } { loosely~dotted }
            { dashed } { dashed }
            { densely-dashed } { densely~dashed }
            { loosely-dashed } { loosely~dashed }
            { dash-dot } { dash~dot }
            { densely-dash-dot } { densely~dash~dot }
            { loosely-dash-dot } { loosely~dash~dot }
            { dash-dot-dot } { dash~dot~dot }
            { densely-dash-dot-dot } { densely~dash~dot~dot }
            { loosely-dash-dot-dot } { loosely~dash~dot~dot }
          }
      }
  }



\AtEndPreamble
  {
    \bool_if:cTF { g__examzh_page_size_a4paper_bool }
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
                inner      = 1.2in,
                outer      = 0.8in,
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
      ]
      % 密封线：线
      \__examzh_sealline_odd_line:
      % 密封线：小圆圈
      \__examzh_sealline_odd_circle:
      % 线上的文字
      \__examzh_sealline_odd_text_around_line:
      % 学生信息
      \__examzh_sealline_odd_infomation:
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

% 线
\cs_new:Npn \__examzh_sealline_odd_line:
  {
    \use:x
      {
        \exp_not:N \draw
          [
            \g__examzh_sealline_odd_type_parameter_tl,
            line~width   = \dim_use:N \g__examzh_sealline_odd_line_thickness_dim
          ]
      }
      ([xshift = -\g__examzh_sealline_odd_line_xshift_dim, yshift = -\g__examzh_sealline_odd_line_yshift_dim]current~page~text~area.north~west)
        --
      ([xshift = -\g__examzh_sealline_odd_line_xshift_dim, yshift = \g__examzh_sealline_odd_line_yshift_dim]current~page~text~area.south~west);
  }
\cs_new:Npn \__examzh_sealline_even_line:
  {
    \use:x
      {
        \exp_not:N \draw
          [
            \g__examzh_sealline_even_type_parameter_tl,
            line~width    = \dim_use:N \g__examzh_sealline_even_line_thickness_dim
          ] 
      }
      ([xshift = \g__examzh_sealline_even_line_xshift_dim, yshift = -\g__examzh_sealline_even_line_yshift_dim]current~page~text~area.north~east)
        --
      ([xshift = \g__examzh_sealline_even_line_xshift_dim, yshift = \g__examzh_sealline_even_line_yshift_dim]current~page~text~area.south~east);
  }

% 小圆圈
\cs_new:Npn \__examzh_sealline_odd_circle:
  {
    \bool_if:NT \g__examzh_sealline_odd_circle_show_bool
      {
        \use:x
          {
            \exp_not:N
            \fill
              [
                decorate,
                decoration =
                  {
                    markings,
                    mark = 
                    between~positions~
                    \fp_use:N \g__examzh_sealline_odd_circle_start_fp
                    ~and~
                    \fp_use:N \g__examzh_sealline_odd_circle_end_fp
                    ~step~
                    \dim_use:N \g__examzh_sealline_odd_circle_step_dim
                    ~with
                      {
                        \exp_not:N
                        \node 
                          [
                            circle,
                            draw         = black, 
                            fill         = white,
                            minimum~size = \dim_use:N \g__examzh_sealline_odd_circle_diameter_dim
                          ]
                          {};
                      }
                  }
              ]
          }
        ([xshift = -\g__examzh_sealline_odd_circle_xshift_dim]current~page~text~area.north~west)
          --
        ([xshift = -\g__examzh_sealline_odd_circle_xshift_dim]current~page~text~area.south~west);
      }
  }
\cs_new:Npn \__examzh_sealline_even_circle:
  {
    \bool_if:NT \g__examzh_sealline_even_circle_show_bool
      {
        \use:x
          {
            \exp_not:N
            \fill
              [
                decorate,
                decoration =
                  {
                    markings,
                    mark = 
                    between~positions~
                    \fp_use:N \g__examzh_sealline_even_circle_start_fp
                    ~and~
                    \fp_use:N \g__examzh_sealline_even_circle_end_fp
                    ~step~
                    \dim_use:N \g__examzh_sealline_even_circle_step_dim
                    ~with
                      {
                        \exp_not:N
                        \node 
                          [
                            circle,
                            draw         = black, 
                            fill         = white,
                            minimum~size = \dim_use:N \g__examzh_sealline_even_circle_diameter_dim
                          ]
                          {};
                      }
                  }
              ]
          }
        ([xshift = \g__examzh_sealline_even_circle_xshift_dim]current~page~text~area.north~east)
          --
        ([xshift = \g__examzh_sealline_even_circle_xshift_dim]current~page~text~area.south~east);
      }
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
            text       = {\g__examzh_sealline_odd_text_tl}
          }
      ]
      ([xshift = -\g__examzh_sealline_odd_text_xshift_dim, yshift = -\g__examzh_sealline_odd_text_yshift_dim]current~page~text~area.north~west)
        --
      ([xshift = -\g__examzh_sealline_odd_text_xshift_dim, yshift = \g__examzh_sealline_odd_text_yshift_dim]current~page~text~area.south~west);
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
            text = { \g__examzh_sealline_even_text_tl }
          }
      ]
      ([xshift = \g__examzh_sealline_even_text_xshift_dim, yshift = -\g__examzh_sealline_even_text_yshift_dim]current~page~text~area.north~east)
        --
      ([xshift = \g__examzh_sealline_even_text_xshift_dim, yshift = \g__examzh_sealline_even_text_yshift_dim]current~page~text~area.south~east);
  }
% 学生信息
\cs_new:Npn \__examzh_sealline_odd_infomation:
  {
    \use:x 
      {
        \exp_not:N
        \path
          [
            decorate,
            decoration =
              {
                text~along~path,
                text~align = \g__examzh_sealline_odd_info_align_tl,
                reverse~path,
                text = {
                  \clist_use:Nn \g__examzh_sealline_odd_info_content_clist 
                    { { \g__examzh_sealline_odd_info_seperator_tl } }
                }
              }
          ]
      }
      ([xshift = -\g__examzh_sealline_odd_info_xshift_dim, yshift = 0mm]current~page~text~area.north~west)
        --
      ([xshift = -\g__examzh_sealline_odd_info_xshift_dim, yshift = \g__examzh_sealline_odd_info_yshift_dim]current~page~text~area.south~west);
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
    \bool_if:cTF { g__examzh_page_size_a4paper_bool }
      {
        % a4paper
        \fancyfoot [ C ]
          {
            \small
            \l__exam_zh_subject_tl 试题第 \thepage { } 页（共 \pageref { LastPage } ~ 页）
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
                \l__exam_zh_subject_tl 试题第 \thepage { } 页（共 \pageref { LastPage } ~ 页）
              }
          }
          {
            % 每页一个页脚
            \fancyfoot [ L ]
              {
                \__examzh_column_box:n
                  {
                    \int_set:Nn \l__examzh_tmp_int { \lastpage@lastpage }
                    \small
                    \l__exam_zh_subject_tl 试题第 
                    % \thepage 
                    \int_eval:n { 2 * \c@page - 1 }
                    { } 页
                    （共 
                    % \pageref { LastPage } 
                    \int_eval:n { 2 * \l__examzh_tmp_int }
                    ~ 页）
                  }
              }
            \fancyfoot [ R ]
              {
                \__examzh_column_box:n
                  {
                    % \int_gincr:N \c@page
                    \int_set:Nn \l__examzh_tmp_int { \lastpage@lastpage }
                    \small
                    \l__exam_zh_subject_tl 试题第 
                    \int_eval:n { 2 * \c@page }
                    { } 
                    页
                    （共 
                    % \pageref { LastPage }
                    \int_eval:n { 2 * \l__examzh_tmp_int }
                    ~ 页）
                  }
              }
          }
      }
  }
\AtEndPreamble { \pagestyle { plain } }
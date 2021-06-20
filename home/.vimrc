" 文件类型侦测
filetype on
" 根据文件类加载对应插件
filetype plugin on

":set fileformat=unix
" 打开语法加亮
:syn on
" 开启增量搜索
:set incsearch
" 搜索大小写不敏感
:set ignorecase
" 关闭兼容模式
set nocompatible
" vim 自身命令行模式智能补全
set wildmenu

" 将 pathogen 置于独立目录中
runtime bundle/pathogen/autoload/pathogen.vim
" 运行pathogen
execute pathogen#infect()

" 显示状态栏
set laststatus=2
" 显示光标位置
set ruler
" 显示行号
"set number
" 高亮显示当前行/列
"set cursorline
"set cursorcolumn
" 高亮显示搜索结果
set hlsearch

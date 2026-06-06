set statusline=
set nocompatible encoding=utf-8 t_Co=256 bg=dark hidden wildmenu showcmd ruler laststatus=2 number cursorline wrap incsearch hlsearch smartcase scrolloff=5 sidescrolloff=5 backspace=indent,eol,start completeopt=menuone,noinsert,noselect paste "relativenumber shortmess+=c updatetime=300 signcolumn=yes undofile noswapfile ignorecase
silent! set clipboard=unnamedplus
" silent! call mkdir(expand('~/.vim/undo'),'p')
" set undodir=~/.vim/undo//
let python_highlight_all=1
let g:is_bash=1
filetype plugin indent on
syntax enable

hi clear
if exists('syntax_on')|syntax reset|endif
let g:colors_name='vscode-dark-modern-256'

let s:H={
\ 'Normal':[188,232,'NONE'],'NormalNC':[188,233,'NONE'],'CursorLine':['NONE',235,'NONE'],'LineNr':[102,233,'NONE'],'CursorLineNr':[187,235,'bold'],'SignColumn':[188,233,'NONE'],'ColorColumn':['NONE',236,'NONE'],
\ 'VertSplit':[238,232,'NONE'],'WinSeparator':[238,232,'NONE'],'Visual':['NONE',24,'NONE'],
\ 'Search':[232,178,'NONE'],'IncSearch':[232,215,'bold'],'MatchParen':[232,75,'bold'],'Pmenu':[188,236,'NONE'],'PmenuSel':[15,32,'bold'],
\ 'Comment':[65,0,'NONE'],'Constant':[75,232,'NONE'],'String':[174,232,'NONE'],'Character':[174,232,'NONE'],'Number':[151,232,'NONE'],'Boolean':[74,232,'NONE'],'Float':[151,232,'NONE'],'Identifier':[153,232,'NONE'],'Function':[33,232,'NONE'],'Statement':[74,232,'NONE'],'Conditional':[175,232,'NONE'],'Repeat':[175,232,'NONE'],'Label':[175,232,'NONE'],
\ 'Operator':[188,232,'NONE'],'Keyword':[74,232,'NONE'],'Exception':[175,232,'NONE'],'PreProc':[175,232,'NONE'],'Include':[175,232,'NONE'],'Define':[75,232,'NONE'],
\ 'Macro':[75,232,'NONE'],'PreCondit':[175,232,'NONE'],'Type':[79,232,'NONE'],'StorageClass':[74,232,'NONE'],'Structure':[79,232,'NONE'],'Typedef':[79,232,'NONE'],
\ 'Special':[215,232,'NONE'],'SpecialChar':[215,232,'NONE'],'Delimiter':[188,232,'NONE'],'Todo':[232,178,'bold'],'Error':[15,203,'bold'],'Underlined':[75,232,'underline'],
\ 'pythonBuiltin':[75,232,'NONE'],'pythonFunction':[187,232,'NONE'],'pythonDecorator':[187,232,'NONE'],'pythonStatement':[74,232,'NONE'],'pythonConditional':[175,232,'NONE'],'pythonRepeat':[175,232,'NONE'],'pythonException':[175,232,'NONE'],'pythonOperator':[74,232,'NONE'],'pythonString':[174,232,'NONE'],'pythonNumber':[151,232,'NONE'],
\ 'shShebang':[65,232,'NONE'],'shComment':[65,232,'NONE'],'shKeyword':[74,232,'NONE'],'shConditional':[175,232,'NONE'],'shLoop':[175,232,'NONE'],'shFunction':[221,232,'NONE'],'shDeref':[75,232,'NONE'],'shVariable':[153,232,'NONE'],'shString':[174,232,'NONE'],'shQuote':[174,232,'NONE'],'shCommandSub':[187,232,'NONE'],'shOperator':[188,232,'NONE'],'shFunctionOne':[226,232,'NONE'],'shFunctionTwo':[187,232,'NONE'],'shStatement':[74,232,'NONE'],'shOption':[187,232,'NONE'],
\ 'SLBegin':[107,0,'NONE'],'SLMode':[0,107,'NONE'],'SLSep':[107,24,'NONE'],'SLFile':[15,24,'NONE'],'SLFileSep':[24,23,'NONE'],'SLGit':[15,23,'NONE'],'SLGitSep':[23,0,'NONE'],'SLRightBegin':[23,0,'NONE'],'SLInfo':[15,23,'NONE'],'SLInfoSep':[24,23,'NONE'],'SLRight':[15,24,'NONE'],'SLEnd':[24,0,'NONE']
\}
for [g,v] in items(s:H)|exe 'hi! '.g.' ctermfg='.v[0].' ctermbg='.v[1].' cterm='.v[2]|endfor

augroup myvimrc
  au!
  au BufRead,BufNewFile * if empty(expand('%:e'))&& &syntax!='vim'|set ft=sh|endif
  au BufRead,BufNewFile * if &ft==''|set ft=sh|endif
  au FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 colorcolumn=88
  au FileType sh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup END

function! FileDir()
  if expand('%') ==# ''
    return getcwd()
  endif
  return fnamemodify(expand('%:p:h'), ':p')
endfunction

function! GitBranch()
  let dir = FileDir()
  let cmd = 'git -C ' . shellescape(dir) . ' rev-parse --abbrev-ref HEAD 2>/dev/null'
  let branch = system(cmd)
  if v:shell_error
    hi SLGitSep    ctermfg=0
    hi SLFileSep   ctermbg=0
    return ''
  endif
  let branch = substitute(branch, '[\r\n\^@]', '', 'g')
  let branch = substitute(branch, '^\s*\|\s*$', '', '')
  return '  '.branch.' '
endfunction
 
function! PowerlineSline()
  let mode_hl = 'SLMode'
  let mode_str = '  command '
  hi SLMode  ctermfg=0 ctermbg=107
  hi SLSep   ctermfg=107
  hi SLBegin     ctermfg=107
  if mode() == 'i'
    let mode_str = '  insert '
    hi SLMode ctermfg=0 ctermbg=137
    hi SLSep  ctermfg=137
    hi SLBegin    ctermfg=137
  elseif mode() == 'v'
    let mode_str = '  visual '
    hi SLMode ctermfg=0 ctermbg=147
    hi SLSep  ctermfg=147
    hi SLBegin    ctermfg=147
  elseif mode() == 'R'
    let mode_str = '  replace '
    hi SLMode ctermfg=0 ctermbg=167
    hi SLSep  ctermfg=167
    hi SLBegin    ctermfg=167
  endif
  let status = '%#SLBegin#' . g:nerd_right_sep
  let status .= '%#SLMode#' . mode_str
  let status .= '%#SLSep#' . g:nerd_left_sep
  let status .= '%#SLFile#' . ' %t %m%r%h%w'
  let status .= "%{&fileformat!='unix'?'['.&fileformat.']':''}"
  let status .= "%{&endofline?'':'[noeol]'}"
  let status .= "%{&bomb?'[BOM]':''}"
  let status .= '%#SLFileSep#' . g:nerd_left_sep
  let status .= '%#SLGit#' . g:git_branch
  let status .= '%#SLGitSep#' . g:nerd_left_sep
  let status .= '%=' " Right-align the rest
  let status .= '%#SLRightBegin#' . g:nerd_right_sep
  let status .= '%#SLInfo#' . ' L%l:C%c '
  let status .= '%#SLInfoSep#' . g:nerd_right_sep
  let status .= '%#SLRight#' . ' %p%% '
  let status .= '%#SLEnd#' . g:nerd_left_sep
  return status
endfunction

let g:git_branch = GitBranch()
let g:powerline_left_sep = ''
let g:powerline_right_sep = ''
let g:nerd_left_sep = ''
let g:nerd_right_sep = ''
set statusline=%!PowerlineSline()


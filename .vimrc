silent! set nocompatible encoding=utf-8 t_Co=256 bg=dark hidden wildmenu noshowcmd ruler laststatus=2 number cursorline wrap incsearch hlsearch smartcase scrolloff=5 sidescrolloff=5 backspace=indent,eol,start viminfo^=% paste completeopt=menuone,noinsert,noselect "relativenumber shortmess+=c updatetime=300 signcolumn=yes undofile noswapfile ignorecase
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
set statusline=
" silent! set clipboard=unnamedplus
nnoremap <M-n> :set nu!<CR>
nnoremap <Esc>n :set nu!<CR>
" silent! call mkdir(expand('~/.vim/undo'),'p')
" set undodir=~/.vim/undo//
let python_highlight_all=1
let g:is_bash=1
filetype plugin indent on
syntax enable

hi clear
if exists('syntax_on')|syntax reset|endif
let g:colors_name='vscode-dark-modern-256'
hi! Normal ctermfg=188 ctermbg=232
hi! NormalNC ctermfg=188 ctermbg=233
function! MySyn()
  for [g,p,l] in [
        \ ['myAssignment','\s*\zs\h\w*\ze\s*\%([[=!+<>)},;. -]\|$\)','Identifier'],
        \ ['myFuncName','\<def\s\+\zs\h\w*\ze\s*(','Function'],
        \ ['myClassName','\<class\s\+\zs\h\w*\ze\%(\s*(\|\s*:\)','Type'],
        \ ['myDecorator','@\h\w*\%(\.\h\w*\)*','PreProc'],
        \ ['myConstant','\<[A-Z][A-Z0-9_]*\>','Constant'],
        \ ['myMethodCall','\.\zs\h\w*\ze\s*(','Function'],
        \ ['myFuncCall','\v\h\w*\ze\s*\(','Function']]
    exe "syntax match ".g." '".p."'"
    exe "hi link ".g." ".l
  endfor
  syntax keyword pythonSelf self cls
  hi link pythonSelf Special
endfunction

augroup myvimrc
  au!
  au BufRead,BufNewFile * if &ft==''||(empty(expand('%:e')) && index(['vim','passwd','group','messages'], &ft) <0) |set ft=sh|endif
  au FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 colorcolumn=130
  au FileType sh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
  au Syntax python,awk,javascript,rust,go,ruby call MySyn()
augroup END

let s:H={
\ 'CursorLine':['NONE',235],'LineNr':[102,233],'CursorLineNr':[187,235,'bold'],'SignColumn':[188,233],'ColorColumn':['NONE',236],
\ 'VertSplit':[238],'WinSeparator':[238],'Visual':['NONE',24],
\ 'Search':[232,178],'IncSearch':[232,215,'bold'],'MatchParen':[232,75,'bold'],'Pmenu':[188,236],'PmenuSel':[15,32,'bold'],
\ 'Comment':[65],'Constant':[75],'String':[174],'Character':[174],'Number':[151],'Boolean':[74],'Float':[151],'Identifier':[153],'Function':[187],'Statement':[74],'Conditional':[175],'Repeat':[175],'Label':[175],
\ 'Operator':[188],'Keyword':[74],'Exception':[175],'PreProc':[175],'Include':[175],'Define':[75],
\ 'Macro':[75],'PreCondit':[175],'Type':[79],'StorageClass':[74],'Structure':[79],'Typedef':[79],
\ 'Special':[215],'SpecialChar':[215],'Delimiter':[188],'Todo':[232,178,'bold'],'Error':[15,203,'bold'],'Underlined':[75,232,'underline'],
\ 'pythonBuiltin':[75],'pythonFunction':[187],'pythonAttribute':[187],'pythonDecorator':[187],'pythonStatement':[74],'pythonConditional':[175],'pythonRepeat':[175],'pythonException':[175],'pythonOperator':[74],'pythonString':[174],'pythonNumber':[151],
\ 'shShebang':[65],'shComment':[65],'shKeyword':[74],'shConditional':[175],'shLoop':[175],'shFunction':[221],'shDeref':[153],'shVariable':[153],'shString':[174],'shQuote':[174],'shCommandSub':[187],'shOperator':[188],'shFunctionOne':[226],'shFunctionTwo':[187],'shSet':[74],'shStatement':[74],'shOption':[187],'shSetList':[153],'shAlias':[153],'shFunctionKey':[74],
\ 'SLBegin':[107],'SLMode':[0,107],'SLSep':[107,24],'SLFile':[15,24],'SLFileSep':[24,23],'SLGit':[15,23],'SLGitSep':[23],'SLRightBegin':[23],'SLInfo':[15,23],'SLInfoSep':[24,23],'SLRight':[15,24],'SLEnd':[24]
\}
for [g,v] in items(s:H)
  exe 'hi! '.g.' ctermfg='.v[0].' ctermbg='.(len(v)>1 && v[1] != '' ? v[1] : 232).' cterm='.(len(v)>2 && v[2] != '' ? v[2] : 'NONE')
endfor


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
  hi SLBegin ctermfg=107
  if mode() == 'i'
    let mode_str = '  insert '
    hi SLMode  ctermfg=0 ctermbg=137
    hi SLSep   ctermfg=137
    hi SLBegin ctermfg=137
  elseif mode() == 'v'
    let mode_str = '  visual '
    hi SLMode  ctermfg=0 ctermbg=147
    hi SLSep   ctermfg=147
    hi SLBegin ctermfg=147
  elseif mode() == 'R'
    let mode_str = '  replace '
    hi SLMode  ctermfg=0 ctermbg=167
    hi SLSep   ctermfg=167
    hi SLBegin ctermfg=167
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

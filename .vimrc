" Reset statusline
set statusline=
" Always show statusline
set laststatus=2

" =============================================
" Powerline Statusline (Terminal Vim)
" =============================================
" Enable 256 colors and Unicode
set t_Co=256
set encoding=utf-8

" Define highlight groups (terminal + GUI compatible)
hi StatusBegin     ctermfg=107 
hi StatusLineMode  ctermfg=0 ctermbg=107 
hi StatusLineSep   ctermfg=107 ctermbg=4
hi StatusLineFile  ctermfg=15  ctermbg=4
hi StatusFileSep   ctermfg=4 ctermbg=8
hi StatusLineGit   ctermfg=15  ctermbg=8
hi StatusGitSep    ctermfg=8
hi StatusRightBegin ctermfg=8
hi StatusLineInfo  ctermbg=8
hi StatusInfoSep   ctermfg=4 ctermbg=8
hi StatusLineRight ctermbg=4 
hi StatusEnd       ctermfg=4

" Unicode symbols (replace if unsupported)
let g:powerline_left_sep = ''
let g:powerline_right_sep = ''
let g:nerd_left_sep = ''
let g:nerd_right_sep = ''

" Return the directory of the current file (absolute path)
function! FileDir()
  if expand('%') ==# ''
    return getcwd()
  endif
  return fnamemodify(expand('%:p:h'), ':p')
endfunction

function! GitBranch()
  let dir = FileDir()
  let cmd = 'cd '. shellescape(dir) . ';git rev-parse --abbrev-ref HEAD 2>/dev/null'
  let branch = system(cmd)
  if v:shell_error
    hi StatusGitSep    ctermfg=0
    hi StatusFileSep   ctermbg=0
    return ''
  endif
  let branch = substitute(branch, '[\r\n\x00]', '', 'g')
  let branch = substitute(branch, '^\s\+|\s\+$', '', 'g')
  return '  '.branch.' '
endfunction

let g:git_branch = GitBranch()

function! GitDirty()
  let dir = FileDir()
  let cmd = 'cd '. shellescape(dir) . ';git -C ' . shellescape(dir) . ' status --porcelain -- . 2>/dev/null'

  let status = system(cmd)
  if v:shell_error
    return 0
  endif
  let status = trim(status)
  return strlen(status) ? 3 : 2
endfunction


" Function to set statusline
function! PowerlineStatusline()
  let mode_hl = 'StatusLineMode'
  let mode_str = '  command '
  hi StatusLineMode ctermfg=0 ctermbg=107 guifg=black guibg=#87af87
  hi StatusLineSep   ctermfg=107 
  hi StatusBegin     ctermfg=107 
  if mode() == 'i'
    let mode_str = '  insert '
    hi StatusLineMode ctermfg=0 ctermbg=137 guifg=black guibg=#87af87
    hi StatusLineSep   ctermfg=137 
    hi StatusBegin     ctermfg=137 
  elseif mode() == 'v'
    let mode_str = '  visual '
    hi StatusLineMode ctermfg=0 ctermbg=147 guifg=black guibg=#af87d7
    hi StatusLineSep   ctermfg=147
    hi StatusBegin     ctermfg=147 
  elseif mode() == 'R'
    let mode_str = '  replace '
    hi StatusLineMode ctermfg=0 ctermbg=167 guifg=black guibg=#d75f5f
    hi StatusLineSep   ctermfg=167
    hi StatusBegin     ctermfg=167 
  endif
  let status = '%#StatusBegin#' . g:nerd_right_sep
  let status .= '%#StatusLineMode#' . mode_str
  let status .= '%#StatusLineSep#' . g:nerd_left_sep
  let status .= '%#StatusLineFile#' . ' %t %m%r%h%w'
  let status .= "%{&fileformat!='unix'?'['.&fileformat.']':''}"
  let status .= "%{&endofline?'':'[noeol]'}"
  let status .= "%{&bomb?'[BOM]':''}"
  let status .= '%#StatusFileSep#' . g:nerd_left_sep
  let status .= '%#StatusLineGit#' . g:git_branch
  let status .= '%#StatusGitSep#' . g:nerd_left_sep
  let status .= '%=' " Right-align the rest
  let status .= '%#StatusRightBegin#' . g:nerd_right_sep
  let status .= '%#StatusLineInfo#' . ' L%l:C%c '
  let status .= '%#StatusInfoSep#' . g:nerd_right_sep
  let status .= '%#StatusLineRight#' . ' %p%% '
  let status .= '%#StatusEnd#' . g:nerd_left_sep

  return status
endfunction

" Set the statusline
set statusline=%!PowerlineStatusline()

if has('reltime')
  set incsearch
endif

if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":autocmd! vimStartup"
  augroup vimStartup
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim), for a commit or rebase message
    " (likely a different one than last time), and when using xxd(1) to filter
    " and edit binary files (it transforms input files back and forth, causing
    " them to have dual nature, so to speak)
    autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif

  augroup END

  " Quite a few people accidentally type "q:" instead of ":q" and get confused
  " by the command line window.  Give a hint about how to get out.
  " If you don't like this you can put this in your vimrc:
  " ":autocmd! vimHints"
  augroup vimHints
    au!
    autocmd CmdwinEnter *
	  \ echohl Todo |
	  \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
	  \ echohl None
  augroup END

endif

set hlsearch
highlight Search guibg=red guifg=black ctermbg=3 ctermfg=black
syntax on
set bg=dark
set paste

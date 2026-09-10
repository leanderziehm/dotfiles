" =========================================================
" Clipboard & Mouse
" =========================================================

set clipboard=unnamedplus
set mouse=a

" Highlight yanking
augroup kickstart-highlight-yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.hl.on_yank()
augroup END


" =========================================================
" VSCODE LIKE COPY / PASTE
" =========================================================

inoremap <silent> <C-v> <C-r>+
nnoremap <silent> <C-v> "+p
vnoremap <silent> <C-v> "+p
vnoremap <silent> <C-z> u


" Ctrl+C like VSCode
function! CopyLikeVSCode()
  if mode() =~# '^[vV]'
    normal! "+y
  else
    normal! "+yy
  endif
endfunction

nnoremap <silent> <C-c> :call CopyLikeVSCode()<CR>
vnoremap <silent> <C-c> :call CopyLikeVSCode()<CR>


" =========================================================
" Move Lines Like VSCode (Alt + Arrow)
" =========================================================

nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==

vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

nnoremap <M-Down> :m .+1<CR>==
nnoremap <M-Up> :m .-2<CR>==

vnoremap <M-Down> :m '>+1<CR>gv=gv
vnoremap <M-Up> :m '<-2<CR>gv=gv


" =========================================================
" Toggle Comment
" =========================================================

function! ToggleComment()

  let cs = &commentstring

  if cs == ''
    return
  endif

  let marker = substitute(cs, '%s', '', '')
  let marker = substitute(marker, '^\s*\(.\{-}\)\s*$', '\1', '')

  let row = line('.')
  let line_text = getline(row)

  if line_text =~ '^\s*' . escape(marker, '\')
    let line_text = substitute(
          \ line_text,
          \ '^\s*' . escape(marker, '\') . '\s\?',
          \ '',
          \ '')
  else
    let line_text = marker . ' ' . line_text
  endif

  call setline(row, line_text)

endfunction


nnoremap <silent> <C-/> :call ToggleComment()<CR>
nnoremap <silent> <C-_> :call ToggleComment()<CR>


" =========================================================
" Restore Cursor Position
" =========================================================

augroup restore_cursor
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ execute "normal! g`\"" |
        \ endif
augroup END



" =========================================================
" Disable Shift + Arrow
" =========================================================

nnoremap <S-Up> <Nop>
inoremap <S-Up> <Nop>
vnoremap <S-Up> <Nop>

nnoremap <S-Down> <Nop>
inoremap <S-Down> <Nop>
vnoremap <S-Down> <Nop>

nnoremap <S-Left> <Nop>
inoremap <S-Left> <Nop>
vnoremap <S-Left> <Nop>

nnoremap <S-Right> <Nop>
inoremap <S-Right> <Nop>
vnoremap <S-Right> <Nop>


" =========================================================
" Auto Save Markdown
" =========================================================

augroup autosave_md
  autocmd!
  autocmd BufLeave,FocusLost,TextChanged *.md
        \ if &modified | silent write | endif
augroup END



" =========================================================
" Leader
" =========================================================

let mapleader=" "
let maplocalleader=" "


" =========================================================
" Theme
" =========================================================

colorscheme zellner


" =========================================================
" Theme Switcher
" =========================================================

let g:themes = getcompletion('', 'color')
let g:current_theme = 0


function! SetTheme(index)

  execute "colorscheme " . g:themes[a:index]

  echo "Theme: " . g:themes[a:index]

endfunction


function! NextTheme()

  let g:current_theme += 1

  if g:current_theme >= len(g:themes)
    let g:current_theme = 0
  endif

  call SetTheme(g:current_theme)

endfunction


function! PrevTheme()

  let g:current_theme -= 1

  if g:current_theme < 0
    let g:current_theme = len(g:themes)-1
  endif

  call SetTheme(g:current_theme)

endfunction


nnoremap <leader>tn :call NextTheme()<CR>



" =========================================================
" Core UI
" =========================================================

set number
set cursorline
set signcolumn=yes
set termguicolors


" =========================================================
" Search
" =========================================================

set ignorecase
set smartcase
set incsearch
set hlsearch


" =========================================================
" Splits
" =========================================================

set splitbelow
set splitright

" =========================================================
" Undo / Swap / Backup (Vim compatible)
" =========================================================

let data_dir = expand('~/.vim')

function! EnsureDir(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction


" Undo
let undo_dir = data_dir . '/undo'
call EnsureDir(undo_dir)

set undofile
execute 'set undodir=' . undo_dir


" Swap
let swap_dir = data_dir . '/swap'
call EnsureDir(swap_dir)

execute 'set directory=' . swap_dir


" Backup
let backup_dir = data_dir . '/backup'
call EnsureDir(backup_dir)

set backup
set writebackup

execute 'set backupdir=' . backup_dir


" Better defaults
set undolevels=1000
set undoreload=10000
set backupcopy=yes


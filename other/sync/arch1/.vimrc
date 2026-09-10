" TODO figure out a good timeout so esc is instant but I still have time to
" press my keys 

syntax on
filetype plugin indent on
set nocompatible
" VISUAL SETTINGS
colorscheme unokai " wildcharm
set number
set cursorline
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END



set ttimeout
set ttimeoutlen=50
"set timeoutlen=3000 " 3 seconds 

" enable mouse
set mouse=a





let mapleader = " "
nnoremap <Space> <Nop> 
" Keyboard shortcuts Vscode
nnoremap <C-Down> :m .+1<CR>==
vnoremap <C-Down> :m .+1<CR>==
" Move current line up with Ctrl + Up
nnoremap <C-Up> :m .-2<CR>==
vnoremap <C-Up> :m .-2<CR>==

" Move current line down with Shift+Down (normal mode)
nnoremap <S-Down> :m .+1<CR>==
vnoremap <S-Down> :m .+1<CR>==
" Move current line up with Shift+Up (normal mode)
nnoremap <S-Up> :m .-2<CR>==
vnoremap <S-Up> :m .-2<CR>==


" Move current line down with Shift+Down (normal mode)
nnoremap <A-Down> :m .+1<CR>==
vnoremap <A-Down> :m .+1<CR>==
" Move current line up with Shift+Up (normal mode)
nnoremap <A-Up> :m .-2<CR>==
vnoremap <A-Up> :m .-2<CR>==




"nnoremap <C-a> mzggVG`z
"inoremap <C-a> ggVG
"vnoremap <C-a> ggVG


" Help


nnoremap <leader>hk :tab help key-notation<CR>
nnoremap <leader>hk :tab help key-notation<CR>

" vimwiki
" Map <leader>Backspace to go to previous buffer
nnoremap <BS> :bp<CR>
nnoremap <leader><BS> :bp<CR>

" Map <leader>Tab to go to next buffer
nnoremap <leader><Tab> :bn<CR>








" GIT (TODO)


" DIFF 
" [TODO(future)] make partial diffs where you can select something in visual
" mode and if and then it diffs that with the clipboard
" Compare clipboard with current buffer, left = buffer, right = clipboard
command! DiffClipboard call DiffClipboard()

function! DiffClipboard()
    " Save clipboard contents to a temporary file
    let tempname = tempname()
    call writefile(split(getreg('+', 1), "\n"), tempname)

    " Open the clipboard file in a vertical split on the right quietly
    " 'silent!' suppresses messages and avoids the hit-enter prompt
    silent! vert rightbelow vsplit
    silent! execute 'edit ' . tempname

    " Configure scratch buffer
    setlocal buftype=nofile bufhidden=wipe nobuflisted
    file [Clipboard]

    " Enable diff in both windows
    wincmd p
    diffthis
    wincmd w
    diffthis

    "[HINT] YOUT HAVE TO FOCUS THE RIGHT WINDOW TO CLOSE WITH q.  Map 'q' to close the clipboard buffer and restore normal view
    nnoremap <buffer> q :q!<CR>
    
    " Return focus to original buffer
    wincmd p
endfunction

nnoremap <leader>dif :DiffClipboard<CR>

"# Search
" Wildmenu & recursive search
set wildmenu
set wildmode=longest:full,full
set path=
"set path+=**

" Case-insensitive unless uppercase used
set ignorecase
set smartcase

" Incremental search
set incsearch
set hlsearch

nnoremap ,p "0p
nnoremap <Space> o<Esc>

set scrolloff=10

" Clipboard
set clipboard=unnamedplus
set is 
set hls


" INDENT
"set relativenumber
"set smartindent
"set autoindent
"set tabstop=4
"set shiftwidth=4
"set expandtab

"autocmd FileType java setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab smartindent

"set showmatch
"set ruler
"set colorcolumn=80


"# Persistence
set viminfo='100,<50,s10,h


" -----------------------------
" Auto recovery for swap files
" -----------------------------
" Automatically recover swap files if they exist
autocmd SwapExists * if !v:swapchoice | let v:swapchoice = 'r' | endif



" disable auto wrapping so if i write so long it wont automatically do it I
" DIDNT WORK ITS STILL DOING IT BELOW 
"set textwidth=0
" Prevent auto-inserting comment leaders on Enter WARNING MAYBE HAS SIDE EFFECTS FOR WRAPPING
"autocmd FileType * setlocal formatoptions-=o
"autocmd FileType * setlocal formatoptions-=r

"Optional: If you still want automatic text wrapping but not comment continuation, make sure formatoptions still includes t (for text wrapping) and q (for gq formatting), for example:
"set formatoptions=tq



" Set the time Vim waits before triggering CursorHold (in milliseconds)
set updatetime=10000  " 10000 ms = 10 seconds

" Function to switch to normal mode if in insert mode
function! GoToNormalIfIdle()
  if mode() ==# 'i'  " Check if we are in insert mode
    stopinsert        " Go back to normal mode
  endif
endfunction

" Trigger function on CursorHold event
autocmd CursorHold * call GoToNormalIfIdle()



"""











" autosave markdown 
autocmd BufLeave,TextChanged,TextChangedI *.md silent! update

" quick quit
nnoremap <S-q> :q<CR>

nnoremap <leader>h :tab help<space>
autocmd FileType help nnoremap <buffer> q :tabclose<CR>



" autoreload vimrc if changed
"autocmd BufEnter $MYVIMRC nnoremap <buffer> <leader>r :w<CR>:source $MYVIMRC<CR>
autocmd BufEnter $MYVIMRC nnoremap <leader>r :w<CR>:source $MYVIMRC<CR>:echo "vimrc reloaded"<CR>
"autocmd BufWritePost $MYVIMRC source $MYVIMRC



"# Search and Explore

" if not using custom statusbar show seach result counts 
:set shortmess-=S


nnoremap <Leader>b :ls<CR>:buffer<Space>
"nnoremap <Leader>f :find <C-d>

" TODO make find work well in a certain directory
"nnoremap <Leader>ff :find ~/dev/wiki/**<CR>


"nnoremap <Leader>ff :lcd %:p:h<Bar>echo "Root set to ".getcwd()<Bar>find ""
"nnoremap <Leader>fF :find<space>

"nnoremap <C-p> :find<Space>
"blue  darkblue  default  delek  desert  elflord  evening  habamax  industry
"koehler  lunaperche  morning  murphy  pablo  peachpuff  quiet  retrobox  ron
"shine slate  sorbet  torte  unokai  wildcharm  zaibatsu  zellner     



nnoremap <leader>ss :call CenteredCmdlineSearch()<CR>

function! CenteredCmdlineSearch()
  botright new
  resize 3
  execute "normal! q/"
endfunction




" Key mappings

nnoremap <C-j> 5j
vnoremap <C-j> 5j
inoremap <C-j> 5j
nnoremap <C-k> 5k
vnoremap <C-k> 5k
inoremap <C-k> 5k


" VSCODE Like 
nnoremap <C-p> :browse find<Space>
nnoremap <C-S-P> :vimgrep /<C-r>=expand("<cword>")<CR>/ **/*<CR>:copen<CR>


" F2 to rename word under cursor or selection
function! RenameWord()
  " Check if in visual mode
  if mode() ==# 'v' || mode() ==# 'V' || mode() ==# "\<C-v>"
    " Get selected text
    normal! gv"zy
    let l:word = @z
  else
    " Get word under cursor
    let l:word = expand('<cword>')
  endif

  " Prompt for replacement
  let l:replacement = input('Replace "' . l:word . '" with: ')

  " If input is empty, abort
  if l:replacement == ''
    echo "Rename canceled"
    return
  endif

  " Do the replacement globally
  execute '%s/\V' . escape(l:word, '/\') . '/' . escape(l:replacement, '/\') . '/g'
  echo 'Replaced "' . l:word . '" with "' . l:replacement . '"'
endfunction

" Map F2 in normal and visual mode
nnoremap <F2> :call RenameWord()<CR>
vnoremap <F2> :<C-u>call RenameWord()<CR>

" todo vimscript in vimrc split this into two seperate functins one for single
" line and one for multi line because multiline is still not working it says 
" Toggle comment for single or multiple lines
function! ToggleComment(...) abort
  let l:cs = &commentstring
  if empty(l:cs)
    return
  endif

  let l:prefix = substitute(l:cs, '%s', '', '')
  let l:prefix = substitute(l:prefix, '\s*$', '', '')

  " Determine line range
  if a:0 == 0
    " No arguments: single line
    let l:start = line('.')
    let l:end = l:start
  elseif a:0 == 2
    " Two arguments passed (start and end line)
    let l:start = a:1
    let l:end = a:2
  else
    echoerr "Invalid number of arguments"
    return
  endif

  " Toggle comment for each line in range
  for l:num in range(l:start, l:end)
    let l:line = getline(l:num)
    if l:line =~ '^\s*' . escape(l:prefix, '/*$.')
      " Uncomment
      call setline(l:num, substitute(l:line, '^\(\s*\)' . escape(l:prefix, '/*$.'), '\1', ''))
    else
      " Comment
      call setline(l:num, substitute(l:line, '^\(\s*\)', '\1' . l:prefix, ''))
    endif
  endfor
endfunction

" Normal mode: toggle single line
nnoremap # :call ToggleComment()<CR>
nnoremap <C-/> :call ToggleComment()<CR>
inoremap <C-/> :call ToggleComment()<CR>

" Visual mode: toggle selected range
vnoremap # :<C-U>call ToggleComment(line("'<"), line("'>"))<CR>
vnoremap <C-/> :<C-U>call ToggleComment(line("'<"), line("'>"))<CR>
inoremap <C-/> :<C-U>call ToggleComment(line("'<"), line("'>"))<CR>

" Map <leader>al to create automatic Markdown link
nnoremap <leader>al :call CreateMarkdownLink()<CR>
nnoremap <CR> :call CreateMarkdownLink()<CR>

function! CreateMarkdownLink()
  " Get the current word under cursor
  let l:word = expand('<cword>')

  " Initialize path array
  let l:path = []

  " Track the last top-level header (#)
  let l:last_h1 = ''
  " Track current subheaders under that H1
  let l:subheaders = []

  " Loop backwards from current line to the start
  for lnum in reverse(range(1, line('.') - 1))
    let l:line = getline(lnum)
    if l:line =~ '^# '
      " Found the closest preceding top-level header
      let l:last_h1 = substitute(l:line, '^#\s*', '', '')
      break
    endif
  endfor

  " If top-level header exists, add it to path (lowercased, underscores)
  if l:last_h1 != ''
    call add(l:path, tolower(substitute(l:last_h1, '\s\+', '_', 'g')))
  endif

  " Find subheaders (##, ###) between H1 and current line
  let l:start_line = l:last_h1 == '' ? 1 : lnum + 1
  for lnum2 in range(l:start_line, line('.') - 1)
    let l:line2 = getline(lnum2)
    if l:line2 =~ '^##\+\s'
      let l:sub = substitute(l:line2, '^##\+\s*', '', '')
      call add(l:path, tolower(substitute(l:sub, '\s\+', '_', 'g')))
    endif
  endfor

  " Construct relative path (lowercase word as well)
  let l:relative_path = './' . join(l:path, '/') . '/' . tolower(l:word) . '.md'

  " Replace current word with Markdown link
  execute "normal! viW"
  execute "normal! c[" . l:word . "](" . l:relative_path . ")"
  " Create the file for the relative path if it doesn't exist
  let l:dir = fnamemodify(l:relative_path, ":h")
  if !isdirectory(l:dir)
    call mkdir(l:dir, "p")
  endif

  if !filereadable(l:relative_path)
    call writefile([], l:relative_path)
  endif
endfunction




":filetype plugin indent on













" File Explorer
nnoremap <C-b> :Lex<Esc>
nnoremap <leader>e :Lex<Esc>
nnoremap <leader>n :Lex<Esc>
" nnoremap <leader>dd :Lexplore %:p:h<CR>

":filetype plugin indent on













" File Explorer
nnoremap <C-b> :Lex<Esc>
nnoremap <leader>e :Lex<Esc>
nnoremap <leader>n :Lex<Esc>
" nnoremap <leader>dd :Lexplore %:p:h<CR>

" Netrw basic settings
let g:netrw_keepdir = 0
let g:netrw_winsize = 20
let g:netrw_banner = 0
let g:netrw_localcopydircmd = 'cp -r'


" Keymaps Netrw
function! NetrwMapping()
    " Navigation
    nmap <buffer> h -^           
    nmap <buffer> l <CR>         
    nmap <buffer> . gh           

    " File/Directory management
    nmap <buffer> af %:w<CR>:buffer #<CR>
    nmap <buffer> ad :call mkdir(input('New directory name: '), 'p')<CR>
    nmap <buffer> r R         

    nmap <buffer> q :Lex<Esc>
    nmap <buffer> <Esc> :Lex<Esc>

endfunction

" Call the function automatically whenever a Netrw buffer is opened
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END


let g:search_count_status = '-'

function! UpdateSearchCount() abort
  if !v:hlsearch
    let g:search_count_status = ''
    return
  endif

  let l:sc = searchcount()
  if l:sc.total > 0
    let g:search_count_status = l:sc.current . '/' . l:sc.total
  else
    let g:search_count_status = ''
  endif
endfunction


augroup SearchCountStatus
  autocmd!
  autocmd CmdlineLeave /,? call UpdateSearchCount()
  autocmd CursorMoved,CursorMovedI * call UpdateSearchCount()
augroup END


"# Status Line
set laststatus=2 " always show status bar


set statusline=
set statusline+=%7*\[%n]                                  " buffernr
set statusline+=%1*\ %<%F\                                " File+path
set statusline+=%2*\ %y\                                  " FileType
set statusline+=%8*\ %=\                                 " Right align
set statusline+=%3*\-%{g:search_count_status}-\ 
set statusline+=%8*\ %=\                                 " Right align
set statusline+=%8*\ %l/%L\                               " Rownumber/total

" From the internet 
augroup VIMRC
    autocmd!
    autocmd BufLeave *.css,*.scss normal! mC
    autocmd BufLeave *.html       normal! mH
    autocmd BufLeave *.js,*.ts    normal! mJ
    autocmd BufLeave *.md         normal! mM
    autocmd BufLeave *.yml,*.yaml normal! mY
augroup END

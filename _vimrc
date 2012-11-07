set nocompatible

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" vimdiff for windows
if has('win32')
	set diffexpr=MyDiff()
	function MyDiff()
		let opt = '-a --binary '
		if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		let arg1 = v:fname_in
		if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		let arg2 = v:fname_new
		if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		let arg3 = v:fname_out
		if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		let eq = ''
		if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
				let cmd = '""' . $VIMRUNTIME . '\diff"'
				let eq = '"'
			else
				let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		else
			let cmd = $VIMRUNTIME . '\diff'
		endif
		silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif

"
" General
"
let mapleader=","

set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

set history=100

" Don't use Ex mode, use Q for formatting
map Q gq

nnoremap <Leader>w :w<CR>
nnoremap <C-S> :w<CR>
nnoremap <Leader>d :DiffOrig<CR>
nnoremap <F4> :close<CR>

nnoremap <Leader>e :edit $MYVIMRC<CR>
nnoremap <Leader>r :source $MYVIMRC<CR>

"
" Display
"
" Hide all gui components,
" Show line information and highlight current line.
set guioptions= number ruler showcmd cursorline cursorcolumn

set scrolloff=3 cmdheight=2 laststatus=2

set tabstop=4 shiftwidth=4

" Show Apply style font and similar TextMate monokai scheme
set guifont=monaco:h11
let g:molokai_original=1
colorscheme molokai

" show tab and trailed space
set list listchars=tab:\|\ ,trail:.,extends:>,precedes:<

"
" Moving
"
" Easy step into wrapped lines
nnoremap j gj
nnoremap k gk

" Move 5 times faster and keep cursor line stay still
nnoremap <Space> gj<C-E>gj<C-E>gj<C-E>gj<C-E>gj<C-E>
nnoremap <BS> gk<C-Y>gk<C-Y>gk<C-Y>gk<C-Y>gk<C-Y>
vnoremap <Space> gj<C-E>gj<C-E>gj<C-E>gj<C-E>gj<C-E>
vnoremap <BS> gk<C-Y>gk<C-Y>gk<C-Y>gk<C-Y>gk<C-Y>

" Prefixed with Ctrl to switch window more faster
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-L> <C-W>l

"
" Editing
"
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U, the same apply to CTRL-W
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

inoremap <F2> Lorem ipsum dolor sit amet, consectetur adipiscing elit.

" Move the cursor to a new line
nnoremap <F8> i<CR><Esc>

" CTRL-X for Cut
vnoremap <C-X> "+x

" CTRL-C for Copy
vnoremap <C-C> "+y

" CTRL-V for Paste
map <C-V> "+gP
cmap <C-V>		<C-R>+
" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>
" Use CTRL-Up to do what CTRL-A used to do
noremap <C-Up> <C-A>
" Use CTRL-Down to do what CTRL-X used to do
noremap <C-Down> <C-X>

" CTRL-A is Select all
noremap <C-A> ggVG
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" Ignore cases, if using capital then case sensitive
set incsearch ignorecase smartcase

nnoremap <silent> <F5> :nohlsearch<Bar>:echo<CR>
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>
nnoremap <silent> <F2> /[^\x00-\x7f]<CR>
"nnoremap <F10> :s/<\(\/\*\)div\(\w\*\)><\(\/\*\)div\(\w\*\)>/<\1div\2>\r<\3div\4>/g<CR>
"nnoremap <F10> :s/<\(\/*\)div\(.*\)><\(\/*\)div\(.*\)>/<\1div\2><\3div\4>/g<CR>
nnoremap <F10> :%s/>\s*</>\r</g<CR>
" Delete all last blank charactors for each line
nnoremap <F11> :%s/[ \t\r]\+$//g<CR>
" Indent entire document
nnoremap <F12> ggVG=

" NERDTree plugin
let NERDTreeQuitOnOpen=1
let NERDTreeChDirMode=2
nnoremap <Leader>ff :NERDTree<Space>
nnoremap <Leader>tt :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeToggle<CR>

" Move cursor in insert mode
inoremap <C-H> <Left>
inoremap <C-L> <Right>
inoremap <C-J> <C-O>gj
inoremap <C-K> <C-O>gk


" Switch to previous or next buffer
nnoremap <S-H> :bprevious<CR>
nnoremap <S-L> :bnext<CR>

" Enable folding: za zA zj zk zi
set foldenable foldmethod=indent foldlevel=2

" Javascript indent fix
let g:SimpleJsIndenter_BriefMode = 1

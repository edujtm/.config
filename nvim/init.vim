
" Some general customizations
set number
set termguicolors
set nohlsearch
set encoding=utf-8

" Indentation
filetype plugin indent on

" Show tabs and spaces
set list
set listchars=tab:!·,trail:·

" Enable code folding
set foldmethod=indent
set foldlevel=99

" Turn off vim recording
map q <Nop>

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
" Config for C# indentation
autocmd FileType cs setlocal shiftwidth=4 tabstop=4 expandtab
autocmd BufNewFile,BufRead *.cshtml set filetype=html

" coc-tsserver sucks asssss
autocmd VimLeavePre * :call coc#rpc#kill()
autocmd VimLeave * if get(g:, 'coc_process_pid', 0) | call system('kill -9 -'.g:coc_process_pid) | endif

" Vundle configuration
set nocompatible 
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim " required for Vundle

call vundle#begin() " Install plugins here

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Gruvbox manages colors of nvim
" Plugin 'morhetz/gruvbox'
Plugin 'gruvbox-community/gruvbox'

" fzf is just awesome
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Code folding plugin for python
Plugin 'Konfekt/FastFold'
Plugin 'tmhedberg/SimpylFold'

" Linters for various languages
Plugin 'dense-analysis/ale'

" deoplete offers text completion
" Plugin 'Shougo/deoplete.nvim'

" Conquer of completion
Plugin 'neoclide/coc.nvim', {'commit': '047a87b01d7d2df2ee1f08ef988ef419051778c1'}

" Kotlin language server
Plugin 'udalov/kotlin-vim'

" Vim Buffer utilities
Plugin 'jeetsukumaran/vim-buffergator'

" Typescript
Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'

Bundle 'OmniSharp/omnisharp-vim'

" Minimap plugin
"
" Couldn't get braille font to work
"
Plugin 'wfxr/minimap.vim'

" Status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Plugin 'datwaft/bubbly.nvim'

" Git integration

Plugin 'tpope/vim-fugitive'

" Cpp syntax highlight
" Plugin 'jackguo380/vim-lsp-cxx-highlight'

" Snippets engine
" Plugin 'SirVer/ultisnips'
" Plugin 'honza/vim-snippets'

" All plugins must be added before this line
call vundle#end() " plugin end
filetype plugin indent on " required for Vundle


" ------- FZF configuration -------

let g:fzf_layout = { 'down': '40%' }

" ------- Gruvbox configuration -------

" autocmd vimenter * ++nested colorscheme gruvbox
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'soft'
set background=dark " Gruvbox dark mode

" ------ Airline configuration -------

" corrige um bug na cor da barra de terminal inativa 
" ao usar airline com gruvbox
let s:saved_theme = []

let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
    for colors in values(a:palette)
        if has_key(colors, 'airline_c') && len(s:saved_theme) ==# 0
            let s:saved_theme = colors.airline_c
        endif
        if has_key(colors, 'airline_term')
            let colors.airline_term = s:saved_theme
        endif
    endfor
endfunction

" ------- Deoplete configuration ------

" let g:deoplete#enable_at_startup = 1

" call deoplete#custom#var('omni', 'input_patterns', {
" \ 'tex': g:vimtex#re#deoplete
" \})

" Snippets configuration
" let g:UltiSnipsExpandTrigger = "<C-j>"
" let g:UltiSnipsJumpForwardTrigger = "<C-b>"
" let g:UltiSnipsJumpBackwardTrigger = "<C-z>"

" ----- ALE Configutarions ------

" Ale was being annoying when used together with veonim
" Disables echo from ALE linters
" let g:ale_echo_cursor = 0
"
" Stops ALE from linting when text is changed
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 0

" Disable LSP because it is a huge PITA
" let g:ale_disable_lsp = 1

let g:ale_linters_explicit = 1
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

" remap undo because I find it extremely annoying
nmap u <Nop>
nmap uu :undo<CR>

" ------- Omnisharp configuration -------

" Corrige alguns erros de highlighting - Issue #660
set hidden

let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_type = 'roslyn'
let g:OmniSharp_prefer_global_sln = 1
let g:OmniSharp_timeout = 10
" let g:OmniSharp_highlighting = 0

highlight csPropertyName guifg=#d3869b
highlight Keyword guifg=#fe8019

let g:OmniSharp_highlight_groups = {
\ 'LocalName': 0,
\ 'ParameterName': 0,
\ 'PropertyName': 'csPropertyName',
\ 'FieldName': 0,
\ 'NamespaceName': 0,
\}

" highlight Identifier guibg=Black guifg=White

" Coc.nvim configuration

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" ------ Goneovim Configurations ------

if exists(':GonvimVersion')

" Opens goneovim file explorer (this works but not what I want)
" autocmd VimEnter * GonvimFilerOpen
" nmap <C-[> :GonvimFilerOpen<CR>
nmap <C-k> :tabe <bar> :GonvimFilerOpen<CR>
" nmap <C-[> :GonvimFilerOpen<CR>

" Paste with Alt p (somehow goneovim erase the paste command)
" That was in Ctrl + Shift + V
nmap <A-p> "+p

" Sometimes I open the file explorer by mistake
" Removed it because I though it was annoying
nmap <Esc> <Nop>
nmap <Tab> :GonvimFilerOpen<CR>

" Goneovim fuzzy finder & minimap
nmap <silent> ,f :GonvimFuzzyFiles<CR>
nmap <silent> ,m :GonvimMiniMap<CR>

endif " Gonvim configuration ---------

" -------  Veonim configuration -------

if exists('veonim')

" Third party customization that do not play well with veonim
let g:ale_echo_cursor = 0
" let g:deoplete#enable_at_startup = 0

" Changes directory when entering veonim
autocmd VimEnter * cd $PWD
" Copy selection with Alt + C
noremap <A-c> "+y<CR>
" Paste with Alt + v
noremap <A-v> "+p

set guicursor=n:block-CursorNormal,i:ver15-CursorInsert,v:block-CursorVisual
hi! CursorNormal guibg=#EBDBB2
hi! CursorInsert guibg=#EBDBB2
hi! CursorVisual guibg=#458588

" Some veonim configurations
nno <silent> ,f :Veonim files<CR>
nno <silent> ,e :Veonim explorer<CR>
nno <silent> ,b :Veonim buffers<CR>
nno <silent> ,d :Veonim change-dir<CR>

" Creates new tab with file opener
nmap <C-k> :tabe <bar> :Veonim files<CR>


" Changing windows (might change later)
nmap <A-h> :wincmd h<CR>
nmap <A-j> :wincmd j<CR>
nmap <A-k> :wincmd k<CR>
nmap <A-l> :wincmd l<CR>

endif " Veonim configutarion -------


" ------ Neovide configuration ------
if exists('neovide')
    set noshowmode
    "set guifont=FiraCode\ Nerd\ Font\ Mono:h14:style=Retina,Regular
    set guifont=JetBrains\ Mono\ NL:h14:style=Regular

    nmap <A-h> :wincmd h<CR>
    nmap <A-j> :wincmd j<CR>
    nmap <A-k> :wincmd k<CR>
    nmap <A-l> :wincmd l<CR>
endif " Neovide configuraiton -------

nmap <A-p> :FZF<CR>

" Open terminal on Ctrl + x (Sometimes it doesnt work properly)
" - Splits the screen
" - Changes to newly created screen
" - Terminal window is too big, so its resized
" - Creates terminal buffer
" - Changes to terminal insert mode
"nmap <C-x> :split<CR> <bar> :wincmd j<CR> <bar> :res -5<CR> <bar> :term<CR> <bar> i

" Abre o terminal - Muito util
nmap <C-x> :call Terminal()<CR>

function! Terminal()
  :set splitbelow
  :set splitright
  :20split
  :set laststatus=0
  :set scl=no
  :set nonu
  :term
endfunction

autocmd TermOpen * startinsert

tnoremap <C-x> <C-\><C-n> <bar> :call ExitTerminal()<CR>

function! ExitTerminal()
  :set nosplitbelow
  :set nosplitright
  :set laststatus=2
  :set scl=yes
  :set number
  :q!
endfunction

" Allows toggling terminal when using Ctrl + X on terminal mode
tnoremap <C-X> <C-\><C-n><CR> <bar> :wincmd q<CR>

" remaps Esc on terminal mode
tnoremap <Esc> <C-\><C-n>

" Shows relative line numbers
set relativenumber


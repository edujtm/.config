
set tabstop=4
set shiftwidth=4
set expandtab

" ale uses all linters by default, which shows linting errors
" if some of them are ill-configured. 
" I only configured ccls properly
let b:ale_linters = ['ccls']

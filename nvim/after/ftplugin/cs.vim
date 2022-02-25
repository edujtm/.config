
" configuration for ale on C# files
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

let g:ale_linters_explicit = 1

nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)

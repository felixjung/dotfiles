set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Configure checkers
let g:syntastic_scss_checkers = ['scss-lint']
" let g:syntastic_html_tidy_exec = ['tidy']
let g:syntastic_javascript_checkers = ['jshint']


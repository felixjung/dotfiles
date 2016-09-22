" Neomake settings
let g:neomake_error_sign = {'text': '✗', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
let g:neomake_open_list = 0
let g:neomake_list_height = 5
let g:neomake_echo_current_error = 0
let g:neomake_place_signs = 1
autocmd! BufWritePost * Neomake

" JavaScript {
  " let g:neomake_javascript_eslint_maker = {
    " \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)'
    " \ }
  let g:neomake_javascript_enabled_makers = ['eslint']
  " Prefer the local ESlint version
  au BufEnter *.js let b:neomake_javascript_eslint_exe = nrun#Which('eslint')
" }

" Sass {
" }

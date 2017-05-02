" Neomake settings
let g:neomake_error_sign = {'text': '✗', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
let g:neomake_open_list = 0
let g:neomake_list_height = 5
let g:neomake_echo_current_error = 0
let g:neomake_place_signs = 1

augroup neomake_group
  autocmd!
  autocmd InsertChange,TextChanged * update | Neomake
  autocmd User NeomakeFinished call UpdateLightline()
augroup END

function! UpdateLightline()
  if !exists('*lightline#update')
    return
  endif

  call lightline#update()
endfunction

" JavaScript {
  let g:neomake_javascript_enabled_makers = ['eslint']
  " Prefer the local ESlint version
  au BufEnter *.js let b:neomake_javascript_eslint_exe = nrun#Which('eslint')
" }
" Typescript {
  au BufEnter *.ts let b:neomake_typescript_tslint_exe = nrun#Which('tslint')
  au BufEnter *.ts let b:neomake_typescript_tsc_exe = nrun#Which('tsc')
" }

" Sass {
" }

" Elm {
  let g:neomake_elm_elmmake_maker = {
    \ 'exe': 'elm-make',
    \ 'buffer_output': 1,
    \ 'errorformat':
      \ '%E%.%#--\ %m\ -%# %f' . ',' .
      \ '%C%l\\|' . ',' .
      \ '%C%.%#'
  \ }

  " Enable elm-make on elm
  let g:neomake_elm_enabled_makers = [ 'elmmake' ]

  " Use neomake to build different files
  augroup neomake_neomake_build
    autocmd! BufRead,BufWritePost *.elm Neomake elmmake
  augroup end Elm
" }

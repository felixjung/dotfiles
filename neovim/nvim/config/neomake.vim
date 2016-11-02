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
  autocmd BufWritePost * Neomake
  autocmd User NeomakeFinished call UpdateLightline()
augroup END

function! UpdateLightline()
  if !exists('*lightline#update')
    return
  endif

  call lightline#update()
endfunction

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

" Typescript {
  let g:neomake_typescript_tslint_maker = {
      \ 'exe': nrun#Which('tslint'),
      \ 'args': ['--exclude node_modules']
      \ }

  let g:neomake_typescript_tsc__maker = {
      \ 'exe': nrun#Which('tsc'),
      \ 'args': ['--noEmit'],
      \ 'append_file': 0,
      \ 'errorformat':
          \ '%E%f %#(%l\,%c): error %m,' .
          \ '%E%f %#(%l\,%c): %m,' .
          \ '%Eerror %m,' .
          \ '%C%\s%\+%m'
      \ }

  let g:neomake_typescript_enabled_makers = ['tslint']
" }

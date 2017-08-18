" Always keep column for Ale signs in gutter.
let g:signcolumns = 'yes'
let g:ale_sign_column_always = 1

" Configure linters for different languages.
" TODO: find out how to only run linters, if they are configured for the
" project.
let g:ale_linters = {
\  'javascript': ['eslint']
\}

let s:warning_icon = ''
let s:error_icon = ''
let s:info_icon = ''

" Custom Ale signs using nerd-fonts.
let g:ale_sign_error = s:error_icon
let g:ale_sign_warning = s:warning_icon
let g:ale_sign_info = s:info_icon

" Custom colors to match lightline.
highlight link ALEWarningSign NeomakeWarningSign
highlight link ALEErrorSign NeomakeErrorSign
highlight link ALEInfoSign NeomakeInfoSign

" Statusline format
" TODO: use nerdfont symbols here (same as for sign column).
let g:ale_statusline_format = [s:error_icon . ' %d', s:warning_icon . ' %d', '']

" Show error/warning for current cursor line below status line.
let g:ale_echo_cursor = 0
let g:ale_echo_msg_error_str = s:error_icon
let g:ale_echo_msg_warning_str = s:warning_icon
let g:ale_echo_msg_format = '[%linter%] %s %severity%'

" Fixers that should be used to automatically fix linting errors.
" TODO: check how to put prettier in here, if the project uses it.
" let g:ale_fixers = {

" \}

" Quickfix window height.
let g:ale_list_window_size = 15

" Don't always lint. It causes bad performance.
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1

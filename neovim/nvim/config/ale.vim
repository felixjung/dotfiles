" Always keep column for Ale signs in gutter.
let g:signcolumns = 'yes'
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0

" Configure linters for different languages.
" TODO: find out how to only run linters, if they are configured for the
" project.
let g:ale_linters = {
\  'javascript': ['eslint']
\}

let s:warning_icon = ''
let s:error_icon = ''
let s:info_icon = ''
let s:checking_icon = 'Checking'

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
let g:ale_statusline_format = [s:checking_icon, s:error_icon . ' %d', s:warning_icon . ' %d', '']

" TODO: remove this again
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = s:warning_icon
let g:lightline#ale#indicator_errors = s:error_icon
let g:lightline#ale#indicator_ok = ''

" Show error/warning for current cursor line below status line.
let g:ale_echo_cursor = 1
let g:ale_echo_msg_error_str = s:error_icon
let g:ale_echo_msg_warning_str = s:warning_icon
let g:ale_echo_msg_format = '[%linter%] %s %severity%'

" Set how errors are shown in lists.
let g:ale_list_window_size = 20
let g:ale_open_list = 0
let g:ale_set_loclist = 1
" let g:ale_set_quickfix = 1

let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

let g:ale_fixers = {
\   'javascript': [
\       'eslint'
\   ],
\   'ruby': [
\       'rubocop'
\   ],
\}

let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_eslint_use_local_config = 1

" Fix shortcut
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)

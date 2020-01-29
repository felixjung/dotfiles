" Always keep column for Ale signs in gutter.
let g:signcolumns = 'yes'
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_cursor_detail = 1
let g:ale_close_preview_on_insert = 1
let g:ale_cursor_detail = 0
let g:ale_echo_delay = 100
let g:ale_change_sign_column_color = 0

" Configure linters for different languages.
let s:warning_icon = ''
let s:error_icon = ''
let s:info_icon = ''
let s:checking_icon = '\uf110'
let s:ok_icon = ''

" Custom Ale signs using nerd-fonts.
let g:ale_sign_error = s:error_icon
let g:ale_sign_warning = s:warning_icon
let g:ale_sign_info = s:info_icon

" Custom colors to match lightline.
highlight link ALEWarningSign NeomakeWarningSign
highlight link ALEErrorSign NeomakeErrorSign
highlight link ALEInfoSign NeomakeInfoSign

" Hover information
let g:ale_set_balloons = 0

" Statusline format
let g:ale_statusline_format = [s:checking_icon, s:error_icon . ' %d', s:warning_icon . ' %d', s:ok_icon]

" TODO: remove this again
let g:lightline#ale#indicator_checking = s:checking_icon
let g:lightline#ale#indicator_warnings = s:warning_icon
let g:lightline#ale#indicator_errors = s:error_icon
let g:lightline#ale#indicator_ok = s:ok_icon

" Show error/warning for current cursor line below status line.
let g:ale_echo_cursor = 1
let g:ale_echo_msg_error_str = s:error_icon
let g:ale_echo_msg_warning_str = s:warning_icon
let g:ale_echo_msg_format = '[%linter%] %s %severity%'

" Set how errors are shown in lists.
let g:ale_list_window_size = 20
let g:ale_open_list = 0
let g:ale_set_loclist = 1

let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

let g:ale_fixers = {
\   'typescript': ['eslint', 'prettier'],
\   'javascript': ['eslint'],
\   'json': ['prettier'],
\   'graphql': ['eslint'],
\   'go': ['goimports'],
\   'ruby': ['rufo', 'rubocop'],
\   'rust': ['rustfmt'],
\   'terraform': ['terraform'],
\   'yaml': ['prettier'],
\   'markdown': ['prettier']
\}

" Fixer options
let g:ale_yaml_prettier_options = '--parser yaml --prose-wrap always --max-width 80'

let g:ale_linters = {
\   'typescript': ['eslint', 'tsserver'],
\   'javascript': ['eslint'],
\   'json': ['jsonlint'],
\   'graphql': ['eslint', 'gqlint'],
\   'go': ['golangci-lint', 'gopls'],
\   'ruby': ['rubocop', 'solargraph'],
\   'rust': ['rls'],
\   'sql': ['sqlint'],
\   'terraform': ['terraform', 'tflint'],
\   'vim': ['vint'],
\   'yaml': ['yamllint'],
\}

" Fix shortcut
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)

" Language server functionality
nmap <silent> <M-r> <Plug>(ale_find_references)
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gds <Plug>(ale_go_to_definition_in_split)
nmap <silent> <M-h> <Plug>(ale_hover)


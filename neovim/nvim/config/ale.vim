" Always keep column for Ale signs in gutter.
let g:signcolumns = 'yes'
let g:ale_sign_column_always = 1

" Configure linters for different languages.
let g:ale_linters = {
\  'javascript': ['eslint']
\}

let s:warning_icon = ''
let s:error_icon = ''
let s:info_icon = ''

" Custom Ale signs using nerd-fonts.
let g:ale_sign_error = s:error_icon
let g:ale_sign_warning = s:warning_icon
let g:ale_sign_info = s:info_icon
" let g:ale_sign_style_error
" let g:ale_sign_style_warning

" Show error/warning for current cursor line below status line.
let g:ale_echo_cursor = 1

" Statusline format
" TODO: use nerdfont symbols here (same as for sign column).
let g:ale_statusline_format = [s:error_icon . ' %d', s:warning_icon . ' %d', '']

" TODO: set colors for ale errors in gutter. Check docs for which errors

" Ale message format.
" let g:ale_echo_msg_format

" Fixers that should be used to automatically fix linting errors.
" TODO: check how to put prettier in here, if the project uses it.
" let g:ale_fixers = {

" \}

" Quickfix window height.
let g:ale_list_window_size = 15


" TODO: set highlights in OneDark theme configuration.
  " `ALEError`        - Items with `'type': 'E'`
  " `ALEWarning`      - Items with `'type': 'W'`
  " `ALEInfo`         - Items with `'type': 'I'`
  " `ALEStyleError`   - Items with `'type': 'E'` and `'sub_type': 'style'`
  " `ALEStyleWarning` - Items with `'type': 'W'` and `'sub_type': 'style'`
  " `ALEErrorSign`        - Items with `'type': 'E'`
  " `ALEWarningSign`      - Items with `'type': 'W'`
  " `ALEInfoSign`         - Items with `'type': 'I'`
  " `ALEStyleErrorSign`   - Items with `'type': 'E'` and `'sub_type': 'style'`
  " `ALEStyleWarningSign` - Items with `'type': 'W'` and `'sub_type': 'style'`

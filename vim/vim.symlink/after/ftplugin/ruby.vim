" Settings for editing javascript
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal shiftwidth=2
setlocal textwidth=0

" Things that should increase vim performance in ruby
setlocal norelativenumber
setlocal nocursorline
setlocal nocursorcolumn
setlocal regexpengine=1

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" Load custom ultisnips, if plugin is installed
if exists(':UltiSnipsAddFiletypes')
  :UltiSnipsAddFiletypes rails
  :UltiSnipsAddFiletypes ruby
endif

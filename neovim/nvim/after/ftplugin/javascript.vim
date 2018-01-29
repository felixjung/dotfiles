" Settings for editing javascript
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal shiftwidth=2
setlocal colorcolumn=81
setlocal textwidth=0

" Load custom ultisnips, if plugin is installed
if exists(':UltiSnipsAddFiletypes')
  :UltiSnipsAddFiletypes javascript
  :UltiSnipsAddFiletypes javascript-angular-sumup
  :UltiSnipsAddFiletypes javascript-es-2015
  :UltiSnipsAddFiletypes javascript-jsdoc
  :UltiSnipsAddFiletypes javascript-jasmine-arrow
  :UltiSnipsAddFiletypes javascript-react
  :UltiSnipsAddFiletypes javascript-react-components
endif

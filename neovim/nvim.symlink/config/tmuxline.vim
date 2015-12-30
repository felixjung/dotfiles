" Set theme
let g:tmuxline_theme='vim_statusline_1'
let g:tmuxline_powerline_separators=0

" Set layout
let g:tmuxline_preset={
  \ 'a'       : '#S',
  \ 'b'       : '',
  \ 'c'       : '',
  \ 'win'     : '[#I: #W]',
  \ 'cwin'    : '#W',
  \ 'x'       : '',
  \ 'y'       : '',
  \ 'z'       : ['#h', '#(curl icanhazip.com)'],
  \ 'options' : {'status-justify' : 'left'}
  \ }


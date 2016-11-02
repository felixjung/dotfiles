let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 200

" Configure completion for different languages
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']
let g:deoplete#sources['javascript'] = ['file', 'ultisnips', 'ternjs']

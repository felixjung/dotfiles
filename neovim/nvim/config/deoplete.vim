let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 200

" Configure completion for different languages
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']
let g:deoplete#sources['javascript'] = ['file', 'ultisnips', 'ternjs']
let g:deoplete#sources['ruby'] = ['file', 'ultisnips', 'omni']
let g:deoplete#sources['elm'] = ['file', 'ultisnips', 'omni']

" Completion patterns
let g:deoplete#omni#input_patterns = get(g:, 'deoplete#omni#input_patterns', {})
let g:deoplete#omni#input_patterns.css  = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.scss = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.sass = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.html = ''
let g:deoplete#omni#input_patterns.javascript = ''
let g:deoplete#omni#input_patterns.ruby =
  \ ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']

" Omni completion functions
" let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
" let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
" let g:deoplete#omni#functions.html = 'htmlcomplete#CompleteTags'
" let g:deoplete#omni#functions.javascript = [
  " \ 'tern#Complete',
  " \ 'jspc#omni'
  " \]

" Ranking marks
call deoplete#custom#set('buffer',        'mark', 'ℬ')
call deoplete#custom#set('tag',           'mark', '⌦')
call deoplete#custom#set('omni',          'mark', '⌾')
call deoplete#custom#set('ternjs',        'mark', '⌁')
call deoplete#custom#set('jedi',          'mark', '⌁')
call deoplete#custom#set('vim',           'mark', '⌁')
call deoplete#custom#set('ultisnips',    'mark', '⌘')
call deoplete#custom#set('around',        'mark', '⮀')
call deoplete#custom#set('syntax',        'mark', '♯')
call deoplete#custom#set('tmux-complete', 'mark', '⊶')

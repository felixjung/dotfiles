let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
  \   'left': [ [ 'mode' ], [ 'filename' ] ],
  \   'right': [ [ 'fugitive' ], [ 'neomake' ] ]
  \ },
  \ 'inactive': {
  \   'left': [ [ 'filename' ] ],
  \   'right': [ [] ]
  \ },
  \ 'component': {
  \   'lineinfo': '%3l:%-2v',
  \   'tagbar': '%{tagbar#currenttag("%s", "")}'
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightLineFugitive',
  \   'filename': 'LightLineFilename',
  \   'fileformat': 'LightLineFileformat',
  \   'filetype': 'LightLineFiletype',
  \   'fileencoding': 'LightLineFileencoding',
  \   'mode': 'LightLineMode',
  \ },
  \ 'component_expand': {
  \   'syntastic': 'SyntasticStatuslineFlag',
  \   'neomake': 'neomake#statusline#LoclistStatus'
  \ },
  \ 'component_type': {
  \   'syntastic': 'error',
  \ },
  \ 'subseparator': { 'left': '', 'right': '' }
\ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '±' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? '' :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ' '
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ lightline#mode()
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost call s:syntastic()
augroup END

function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

" Set the colorscheme. Modified from onedark.vim
if exists('g:lightline')

  " These are the colour codes that are used in the original onedark theme
  let s:black        = ['#282c34', 235]
  let s:white        = ['#abb2bf', 145]
  let s:light_red    = ['#e06c75', 204]
  let s:dark_red     = ['#be5046', 196]
  let s:green        = ['#98c379', 114]
  let s:light_yellow = ['#e5c07b', 180]
  let s:dark_yellow  = ['#d19a66', 173]
  let s:blue         = ['#61afef', 39]
  let s:dark_blue    = ['#4e88ff', 400]
  let s:magenta      = ['#c678dd', 170]
  let s:cyan         = ['#56b6c2', 38]
  let s:gutter_grey  = ['#636d83', 238]
  let s:comment_grey = ['#5c6370', 59]


  let s:p = {'normal':{}, 'inactive':{}, 'insert':{}, 'replace':{}, 'visual':{}, 'tabline':{}}

  let s:p.normal.left     = [ [ s:gutter_grey, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.normal.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.normal.middle   = [ [ s:comment_grey, s:black ] ]


  let s:p.inactive.left   = [ [ s:comment_grey, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.inactive.right  = [ [ s:comment_grey, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.inactive.middle = [ [ s:comment_grey, s:black ] ]

  let s:p.insert.left     = [ [ s:green, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.insert.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.insert.middle   = [ [ s:comment_grey, s:black ] ]

  let s:p.replace.left     = [ [ s:light_red, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.replace.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.replace.middle   = [ [ s:comment_grey, s:black ] ]

  let s:p.visual.left     = [ [ s:magenta, s:black ], [ s:comment_grey, s:black ] ]
  let s:p.visual.right    = [ [ s:dark_blue, s:black ], [ s:light_red, s:black ] ]
  let s:p.visual.middle   = [ [ s:comment_grey, s:black ] ]

  let s:p.tabline.left    = [ [ s:comment_grey, s:black ] ]
  let s:p.tabline.right   = [ [ s:gutter_grey, s:black ] ]
  let s:p.tabline.middle  = [ [ s:black, s:black ] ]
  let s:p.tabline.tabsel  = [ [ s:white, s:black ] ]

  let s:p.normal.error    = [ [ s:light_red, s:black ] ]
  let s:p.normal.warning  = [ [ s:light_yellow, s:black ] ]


  let g:lightline#colorscheme#onedark#palette = lightline#colorscheme#flatten(s:p)
endif

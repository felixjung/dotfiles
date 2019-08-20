let g:lightline = {
  \ 'colorscheme': 'palenight',
  \ 'active': {
  \   'left': [ [ 'mode' ], [ 'filename', 'filetype'] ],
  \   'right': [ [ 'fugitive' ], [ 'AleError', 'AleWarning', 'AleOk' ] ]
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
  \   'AleChecking': 'lightline#ale#checking',
  \   'AleError':   'lightline#ale#errors',
  \   'AleWarning': 'lightline#ale#warnings',
  \   'AleOk':      'lightline#ale#ok',
  \ },
  \ 'component_type': {
  \   'AleChecking': 'left',
  \   'AleError':   'error',
  \   'AleWarning': 'warning',
  \   'AleOk':      'ok',
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
        \ fname == '__vista__' ? '' :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() : '') : ''
endfunction

function! LightLineFileFormat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
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

" Set the colorscheme. Modified from onedark.vim
if exists('g:lightline')
  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

  let s:p_vertsplit = ["#181A1F", 59, 15]
  let s:p_special_grey = ["#3B4048", 238, 15]
  let s:p_menu_grey = ["#3E4452", 237, 8]
  let s:p_cursor_grey = ["#2C323C", 236, 8]
  let s:p_gutter_fg_grey = ["#4B5263", 238, 15]
  let s:p_blue = ["#82b1ff", 39, 4]
  let s:p_dark_red = ["#BE5046", 196, 9]
  let s:p_white = ["#bfc7d5", 145, 7]
  let s:p_green = ["#C3E88D", 114, 2]
  let s:p_purple = ["#c792ea", 170, 5]
  let s:p_yellow = ["#ffcb6b", 180, 3]
  let s:p_light_red = ["#ff869a", 204, 1]
  let s:p_red = ["#ff5370", 204, 1]
  let s:p_dark_yellow = ["#F78C6C", 173, 11]
  let s:p_cyan = ["#89DDFF", 38, 6]
  let s:p_comment_grey = ["#697098", 59, 15]
  let s:p_black = ["#292D3E", 235, 0]

  let s:p.normal.left     = [ [ s:p_black, s:p_blue ], [ s:p_blue, s:p_menu_grey ] ]
  let s:p.normal.right    = [ [ s:p_black, s:p_blue ], [ s:p_blue, s:p_menu_grey ] ]
  let s:p.normal.middle   = [ [ s:p_comment_grey, s:p_black ] ]
  let s:p.normal.warning  = [ [ s:p_black, s:p_yellow ] ]
  let s:p.normal.error    = [ [ s:p_black, s:p_red ] ]

  let s:p.insert.left     = [ [ s:p_black, s:p_blue ], [ s:p_blue, s:p_menu_grey ] ]
  let s:p.insert.right    = copy(s:p.insert.left)
  let s:p.insert.middle   = copy(s:p.normal.middle)

  let s:p.visual.left     = [ [ s:p_black, s:p_purple ], [ s:p_purple, s:p_menu_grey ] ]
  let s:p.visual.right    = copy(s:p.visual.left)
  let s:p.visual.middle   = copy(s:p.normal.middle)

  let s:p.replace.left    = [ [ s:p_black, s:p_green ], [ s:p_green, s:p_menu_grey ] ]
  let s:p.replace.right   = copy(s:p.replace.left)
  let s:p.replace.middle  = copy(s:p.normal.middle)

  let s:p.tabline.left    = [ [ s:p_black, s:p_yellow ] ]
  let s:p.tabline.right   = copy(s:p.tabline.left)
  let s:p.tabline.middle  = [ [ s:p_black, s:p_menu_grey ] ]
  let s:p.tabline.tabsel  = [ [ s:p_black, s:p_yellow ] ]

  let s:p.inactive.left   = [ [ s:p_black, s:p_menu_grey ], [ s:p_black, s:p_menu_grey ] ]
  let s:p.inactive.right  = copy(s:p.inactive.left)
  let s:p.inactive.middle = [ [ s:p_black, s:p_menu_grey ] ]

  let g:lightline#colorscheme#palenight#palette = lightline#colorscheme#flatten(s:p)
endif

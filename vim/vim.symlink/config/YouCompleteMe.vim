  au FileType tex let g:ycm_min_num_of_chars_for_completion=99

  let g:ycm_complete_in_strings=0

  let g:ycm_filetype_blacklist={
    \   'notes' : 1,
    \   'markdown' : 1,
    \   'text' : 1,
    \}

  " No need to use YCM as syntastic checker, yet. Maybe for Go.
  let g:ycm_register_as_syntastic_checker = 1

  let g:ycm_autoclose_preview_window_after_completion = 0
  let g:ycm_autoclose_preview_window_after_insertion = 0
  let g:ycm_cache_omnifunc = 1
" }

set completeopt=menu,preview,longest

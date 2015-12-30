let g:tex_flavor="latex"
let g:tex_conceal="adgms" " Conceal everything
let g:LatexBox_latexmk_preview_continuously=1
let g:LatexBox_output_type="pdf"
let g:LatexBox_viewer="open -a Skim"
let g:LatexBox_latexmk_options=""
let g:LatexBox_quickfix=2
let g:LatexBox_build_dir="build"
let g:LatexBox_show_warnings=1
let g:LatexBox_open_pats=[]
let g:LatexBox_close_pats=[]
" Search with Synctex
map <silent> <Leader>ls :silent
  \ !/Applications/Skim.app/Contents/SharedSupport/displayline
  \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>"
  \ "%:p" <CR>


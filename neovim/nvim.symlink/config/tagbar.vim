let g:tagbar_show_linenumbers=0
let g:tagbar_compact=1
nnoremap <silent> <leader>t :TagbarToggle<CR>

" Specific grammars {
" R {
  let g:tagbar_type_r={
    \ 'ctagstype' : "R",
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
    \ ]
  \ }
" }

" go {
  let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
          \ 'p:package',
          \ 'i:imports:1',
          \ 'c:constants',
          \ 'v:variables',
          \ 't:types',
          \ 'n:interfaces',
          \ 'w:fields',
          \ 'e:embedded',
          \ 'm:methods',
          \ 'r:constructor',
          \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
          \ 't' : 'ctype',
          \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
          \ 'ctype' : 't',
          \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
  \ }
" }

" julia {
  let g:tagbar_type_julia={
    \ 'ctagstype' : 'julia',
    \ 'kinds' : [
      \ 'f:function',
      \ 't:type',
      \ ]
    \ }
" }

" Snippet files {
  let g:tagbar_type_snippets={
    \ 'ctagstype' : 'snippets',
    \ 'kinds' : [
        \ 's:snippets',
      \ ]
    \ }
" }

" Markdown {
  let g:tagbar_type_markdown={
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3',
      \ ]
    \ }
" }

" Makefile {
  let g:tagbar_type_make={
    \ 'kinds':[
      \ 'm:macros',
      \ 't:targets'
      \ ]
    \}
" }

" Objective C {
  let g:tagbar_type_objc={
      \ 'ctagstype' : 'ObjectiveC',
      \ 'kinds'     : [
          \ 'i:interface',
          \ 'I:implementation',
          \ 'p:Protocol',
          \ 'm:Object_method',
          \ 'c:Class_method',
          \ 'v:Global_variable',
          \ 'F:Object field',
          \ 'f:function',
          \ 'p:property',
          \ 't:type_alias',
          \ 's:type_structure',
          \ 'e:enumeration',
          \ 'M:preprocessor_macro',
      \ ],
      \ 'sro'        : ' ',
      \ 'kind2scope' : {
          \ 'i' : 'interface',
          \ 'I' : 'implementation',
          \ 'p' : 'Protocol',
          \ 's' : 'type_structure',
          \ 'e' : 'enumeration'
      \ },
      \ 'scope2kind' : {
          \ 'interface'      : 'i',
          \ 'implementation' : 'I',
          \ 'Protocol'       : 'p',
          \ 'type_structure' : 's',
          \ 'enumeration'    : 'e'
      \ }
  \ }
" }

" don't give |ins-completion-menu| messages.  For example,
" '-- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c

let g:cm_complete_delay = 400

" Set up CSS/Sass completion.
au User CmSetup call cm#register_source({'name' : 'cm-css',
		\ 'priority': 9,
		\ 'scoping': 1,
		\ 'scopes': ['css','scss'],
		\ 'abbreviation': 'css',
		\ 'cm_refresh_patterns':[':\s+\w*$'],
		\ 'cm_refresh': {'omnifunc': 'csscomplete#CompleteCSS'},
		\ })

" don't give |ins-completion-menu| messages.  For example,
" '-- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c

let g:cm_complete_delay = 80
let g:cm_complete_start_delay = 200

let g:cm_sources_override = {
\   'cm-tmux': { 'enable': 0 },
\   'cm-tags': { 'enable': 0 },
\   'cm-bufkeyword': { 'enable': 1 },
\   'cm-keyword-continue': { 'enable': 1 }
\ }

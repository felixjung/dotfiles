let g:deoplete#enable_at_startup = 1

" Use ALE and also some plugin 'foobar' as completion sources for all code.
call deoplete#custom#option('sources', {
\ '_': ['ale', 'emoji'],
\})

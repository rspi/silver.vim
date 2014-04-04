command! -bang -nargs=* -complete=file SS call silver#Search('grep<bang>',<q-args>)

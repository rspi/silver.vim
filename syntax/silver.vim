if exists("b:current_syntax")
  finish
endif

syntax match silver_linenr "\v^([0-9]+)"
syntax match silver_path "\v^([^0-9\n]+)"
highlight link silver_linenr Number
highlight link silver_path Identifier

let b:current_syntax = "agresult"

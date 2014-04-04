if exists("b:current_syntax")
  finish
endif

syntax match silverLineNr "\v^([0-9]+)"
syntax match silverPath "^\(\d\+:\)\@!.*"

highlight def link silverLineNr Number
highlight def link silverPath Identifier

let b:current_syntax = "silver"

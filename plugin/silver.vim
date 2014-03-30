" silver.vim - a wrapper for 'The Silver Searcher'.

if !exists("g:ag_command")
  let g:ag_command = "ag"
endif

function! silver#Sup(cmd, args)
  redraw

  if empty(a:args)
    " open last search buffer
    split agresult
    nnoremap <buffer> <silent> q :q<cr>
    setlocal filetype=agresult
    setlocal buftype=nofile
  else

    let l:grepargs = a:args . join(a:000, ' ')
    let output = system(g:ag_command . " -i " . "'" . l:grepargs . "'")

    " exit if no results
    if empty(output)
      echom "No matches for '" . l:grepargs . "'."
      return
    end

    " if already open, use that window
    let winnr = bufwinnr("agresult")
    if ( winnr >= 0 )
      execute winnr . "wincmd w"
    else
      split agresult
    endif

    nnoremap <buffer> <silent> q :q<cr>
    setlocal filetype=agresult
    setlocal buftype=nofile
    normal! ggdG

    let lines = split(output, '\v\n')
    let currentFile = " "

    for line in lines
      let filename = split(line, ':')[0]
      let text = join(split(line, ':')[1:] ,":")
      if currentFile != filename
        call append(line('$'), '')
        call append(line('$'), filename)
        let currentFile = filename
      endif
      call append(line('$'), text)
    endfor

    let winnr = bufwinnr("agresult")
    execute winnr . "wincmd w"
    let @/=a:args
    set hlsearch
    set syntax=silver
    redraw!

  endif

endfunction

command! -bang -nargs=* -complete=file SS call silver#Sup('grep<bang>',<q-args>)

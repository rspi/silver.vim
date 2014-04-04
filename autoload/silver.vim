" silver.vim - a wrapper for 'The Silver Searcher'.
" maintainer: Rasmus Spiegelberg

if !exists("g:ag_command")
  let g:ag_command = "ag"
endif

function! silver#OpenFile(window)
  if (expand('<cword>') != '')
    let savedA = @a
    let savedB = @b
    let @a = 0
    let @b = ''

    normal! 0"ayt:
    normal! {j"by$
    normal q

    if (a:window == 'horizontal')
      execute ':split +' . @a . ' ' . @b
    elseif (a:window == 'vertical')
      execute ':below vsplit +' . @a . ' ' . @b
    elseif (a:window == 'tab')
      execute ':tabe +' . @a . ' ' . @b
    else
      execute ':e +' . @a . ' ' . @b
    endif

    let @a = savedA
    let @b = savedB
  endif
endfunction

function! silver#Search(cmd, args)

  " open last search if no args
  if empty(a:args)
    split agresult
    setlocal filetype=silver
    setlocal buftype=nofile
    execute "resize " . (winheight(0) * 5/3)
  else

    let l:grepargs = a:args . join(a:000, ' ')
    let output = system(g:ag_command . " '" . l:grepargs . "'")

    if empty(output)
      echom "No matches for '" . l:grepargs . "'"
      return
    end

    " if already open, use that window
    let winnr = bufwinnr("agresult")
    if (winnr >= 0)
      execute winnr . "wincmd w"
    else
      split agresult
      execute "resize " . (winheight(0) * 5/3)

      setlocal filetype=silver
      setlocal buftype=nofile

      nnoremap <buffer> <silent> <cr> :call silver#OpenFile('same')<cr>
      nnoremap <buffer> <silent> o :call silver#OpenFile('same')<cr>
      nnoremap <buffer> <silent> q :q<cr>
      nnoremap <buffer> <silent> t :call silver#OpenFile('tab')<cr>
      nnoremap <buffer> <silent> s :call silver#OpenFile('horizontal')<cr>
      nnoremap <buffer> <silent> v :call silver#OpenFile('vertical')<cr>
    endif

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
    normal! ggdd
    let @/=a:args
  endif

endfunction

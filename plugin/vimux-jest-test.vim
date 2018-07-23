command! RunJest :call _run_jest("")
command! RunJestOnBuffer :call RunJestOnBuffer()
command! RunJestFocused :call RunJestFocused()

function! RunJestOnBuffer()
  call _run_jest(expand("%"))
endfunction

function! RunJestFocused()
  let test_name = _jest_test_search('\<test(\|\<it(\|\<test.only(') "note the single quotes

  if test_name == ""
    echoerr "Couldn't find test name to run focused test."
    return
  endif

  call _run_jest(expand("%") . " -t " . test_name)
endfunction

function! _jest_test_search(fragment)
  let line_num = search(a:fragment, "bs")
  if line_num > 0
    ''
    return split(split(getline(line_num), "(")[1], ",")[0]
  else
    return ""
  endif
endfunction

function! _run_jest(test)
  call VimuxRunCommand("CI=true yarn test " . a:test)
endfunction

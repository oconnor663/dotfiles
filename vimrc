" remap backspace to last file
nnoremap <BS> <C-^>

" Founder/FZF settings
function OpenFounder()
  let l:filepath = system("founder --tmux --no-newline")
  if v:shell_error == 0
    execute "e ".fnameescape(l:filepath)
  endif
endfunction
nnoremap <C-t> :call OpenFounder()<CR>
autocmd BufEnter * call system("founder add " . fnameescape(@%))

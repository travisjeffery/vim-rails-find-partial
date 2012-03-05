if exists('g:loaded_rails_find_partial') || &cp || v:version < 700
  finish
endif
let g:loaded_rails_find_partial = 1

autocmd User BufEnterRails call RpartialCommand() 

function! RpartialCommand()
  command! -buffer -nargs=? Rpartial call s:Rpartial(<q-args>) 
endfunction

function! s:Rpartial(...)
  if (len(a) > 0)
    let pattern = "partial.*" . a:0
  else
    let path = substitute(expand("%:h"), "app/views/", "", "")
    let action = substitute(expand("%:t:r:r"), "^_", "", "")
    let pattern = "partial.*" . path . "/" . action 
  endif

  if (exists('g:ackprg'))
    execute "Ack " . '"' . pattern . '\b" app/views'
  elseif (exists('g:loaded_fugitive'))
    execute "Ggrep -P " . '"' . pattern . '\b" app/views'
  else
    " seriously? use git grep or ack! 
    execute "vimgrep " . '"' . pattern . '\>" app/views/*/**'
  endif
endfunction

if exists('g:loaded_rails_find_partial') || &cp || v:version < 700
  finish
endif
let g:loaded_rails_find_partial = 1

augroup railsProjectDetect
  autocmd!
  autocmd VimEnter * if exists("b:rails_root") | silent command! -buffer -nargs=? Rpartial call Rpartial(<q-args>) | endif
  autocmd FileType netrw  if exists("b:rails_root") | silent command! -buffer -nargs=? Rpartial call Rpartial(<q-args>) | endif
  autocmd BufEnter * if exists("b:rails_root")|silent command! -buffer -nargs=? Rpartial call Rpartial(<q-args>)|endif
augroup END

function! Rpartial(partial)
  if (a:partial)
    let pattern = "partial.*" . partial
  else
    let path = substitute(expand("%:h"), "app/views/", "", "")
    let action = substitute(expand("%:t:r:r"), "^_", "", "")
    let pattern = "partial.*" . path . "/" . action 
  endif

  if (exists('g:loaded_fugitive'))
    execute "Ggrep -P " . '"' . pattern . '\b" app/views'
  elseif (exists('g:ackprg'))
    execute "Ack " . '"' . pattern . '\b" app/views'
  else
    " seriously? use git grep or ack! 
    execute "vimgrep " . '"' . pattern . '\>" app/views/*/**'
  endif
endfunction

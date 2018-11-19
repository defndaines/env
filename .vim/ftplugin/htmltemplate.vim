" The htmlheader plugin 
" originally created by Linus Claußnitzer
" Version daines
" Copyright by Linus Claußnitzer
" Email: linus.vivaldi@gmail.com

call setline(1, '<!DOCTYPE html>')
call setline(2, '<html lang="en">')
call setline(3, '<head>')
call setline(4, '<meta charset="utf-8">')
call setline(5, '<title></title>')
call setline(6, '</head>')
call setline(7, '<body>')
call setline(8, '<div class="container">')
call setline(9, '')
call setline(10, '</div>')
call setline(11, '</body>')
call setline(12, '</html>')

normal gg=G

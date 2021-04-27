" The htmlheader plugin 
" originally created by Linus Claußnitzer
" Version daines
" Copyright by Linus Claußnitzer
" Email: linus.vivaldi@gmail.com

call setline(1, '<!DOCTYPE html>')
call setline(2, '<html lang="en">')
call setline(3, '<head>')
call setline(4, '<meta charset="UTF-8">')
call setline(5, '<meta name="viewport" content="width=device-width, initial-scale=1">')
call setline(6, '<title></title>')
call setline(7, '</head>')
call setline(8, '<body>')
call setline(9, '<div class="container">')
call setline(10, '')
call setline(11, '</div>')
call setline(12, '</body>')
call setline(13, '</html>')

normal gg=G

" The htmlheader plugin
" originally created by Linus Claußnitzer
" Version daines
" Copyright by Linus Claußnitzer
" Email: linus.vivaldi@gmail.com

call setline(1, '<!doctype html>')
call setline(2, '<html lang="en">')
call setline(3, '<head>')
call setline(4, '<meta charset="UTF-8">')
call setline(5, '<meta name="viewport" content="width=device-width, initial-scale=1.0">')
call setline(6, '<title></title>')
call setline(7, '<meta name="description" content="">')
call setline(8, '</head>')
call setline(9, '<body>')
call setline(10, '<header>')
call setline(11, '<h1></h1>')
call setline(12, '</header>')
call setline(13, '<div class="container">')
call setline(14, '')
call setline(15, '</div>')
call setline(16, '</body>')
call setline(17, '</html>')

normal gg=G

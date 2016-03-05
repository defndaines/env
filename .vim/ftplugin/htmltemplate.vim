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
call setline(6, '')
call setline(7, '<script type="text/javascript" charset="utf8" src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.6.1/lodash.min.js"></script>')
call setline(8, '<script type="text/javascript" charset="utf8" src="https://code.jquery.com/jquery-2.2.1.min.js"></script>')
call setline(9, '</head>')
call setline(10, '<body>')
call setline(11, '<div class="container">')
call setline(12, '')
call setline(13, '</div>')
call setline(14, '</body>')
call setline(15, '</html>')

normal gg=G

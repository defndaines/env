nnoremap <leader>k :call KindleGenPrep()<CR>

function! KindleGenPrep()
  if search('“')
    execute '%s/“/\&ldquo;/g'
  endif
  if search('”')
    execute '%s/”/\&rdquo;/g'
  endif
  if search('‘')
    execute '%s/‘/\&lsquo;/g'
  endif
  if search('’')
    execute '%s/’/\&rsquo;/g'
  endif
  if search('—')
    execute '%s/\s*—\s*/\&mdash;/g'
  endif
  if search('–')
    execute '%s/–/\&ndash;/g'
  endif
  if search('…')
    execute '%s/…/\&hellip;/g'
  endif
  if search(' ')
    execute '%s/ / /g'
  endif
  if search('à')
    execute '%s/à/\&agrave;/g'
  endif
  if search('á')
    execute '%s/á/\&aacute;/g'
  endif
  if search('è')
    execute '%s/è/\&egrave;/g'
  endif
  if search('é')
    execute '%s/é/\&eacute;/g'
  endif
  if search('ì')
    execute '%s/ì/\&igrave;/g'
  endif
  if search('í')
    execute '%s/í/\&iacute;/g'
  endif
  if search('ò')
    execute '%s/ò/\&ograve;/g'
  endif
  if search('ó')
    execute '%s/ó/\&oacute;/g'
  endif
  if search('ù')
    execute '%s/ù/\&ugrave;/g'
  endif
  if search('ú')
    execute '%s/ú/\&uacute;/g'
  endif
  if search('À')
    execute '%s/À/\&Agrave;/g'
  endif
  if search('Á')
    execute '%s/Á/\&Aacute;/g'
  endif
  if search('È')
    execute '%s/È/\&Egrave;/g'
  endif
  if search('É')
    execute '%s/É/\&Eacute;/g'
  endif
  if search('Ì')
    execute '%s/Ì/\&Igrave;/g'
  endif
  if search('Í')
    execute '%s/Í/\&Iacute;/g'
  endif
  if search('Ò')
    execute '%s/Ò/\&Ograve;/g'
  endif
  if search('Ó')
    execute '%s/Ó/\&Oacute;/g'
  endif
  if search('Ù')
    execute '%s/Ù/\&Ugrave;/g'
  endif
  if search('Ú')
    execute '%s/Ú/\&Uacute;/g'
  endif
  if search('ç')
    execute '%s/ç/\&ccedil;/g'
  endif

  "" Convert Macrons for Romanized Japanese.
  if search('ā')
    execute '%s/ā/aa/g'
  endif
  if search('ē')
    execute '%s/ē/ee/g'
  endif
  if search('ī')
    execute '%s/ī/ii/g'
  endif
  if search('ō')
    execute '%s/ō/ou/g'
  endif
  if search('ū')
    execute '%s/ū/uu/g'
  endif
  if search('Ā')
    execute '%s/Ā/Aa/g'
  endif
  if search('Ē')
    execute '%s/Ē/Ee/g'
  endif
  if search('Ī')
    execute '%s/Ī/Ii/g'
  endif
  if search('Ō')
    execute '%s/Ō/Ou/g'
  endif
  if search('Ū')
    execute '%s/Ū/Uu/g'
  endif
  " These don't work with the current gen script
  " :%s/ā/\&amacr;/g
  " :%s/ē/\&emacr;/g
  " :%s/ī/\&imacr;/g
  " :%s/ō/\&omacr;/g
  " :%s/ū/\&umacr;/g
  " :%s/Ā/\&Amacr;/g
  " :%s/Ē/\&Emacr;/g
  " :%s/Ī/\&Imacr;/g
  " :%s/Ō/\&Omacr;/g
  " :%s/Ū/\&Umacr;/g

  "" Clean up HTML Tags
  if search('<body[^>]*>')
    execute '%s/<body[^>]*>/<body>\r/g'
  endif
  if search('<h1 [^>]*>')
    execute '%s/<h1 [^>]*>/\r<h1>/g'
  endif
  if search('<h2 [^>]*>')
    execute '%s/<h2 [^>]*>/\r<h2>/g'
  endif
  if search('<h3 [^>]*>')
    execute '%s/<h3 [^>]*>/\r<h3>/g'
  endif
  if search('<p [^>]*>')
    execute '%s/<p [^>]*>/\r<p>/g'
  endif
  if search('<a [^>]*>')
    execute '%s/<a [^>]*>//g'
  endif
  if search('</a>')
    execute '%s#</a>##g'
  endif
  if search('<span[^>]*>')
    execute '%s/<span[^>]*>//g'
  endif
  if search('</span>')
    execute '%s#</span>##g'
  endif
  " if search('<meta[^>]*>')
    " execute '%s/<meta[^>]*>/\r&/g'
  " endif
  if search(' style="[^"]*"')
    execute '%s/ style="[^"]*"//g'
  endif
  if search('<!--.\{-}-->')
    execute '%s/<!--.\{-}-->//g'
  endif

  " Strip references to external stylesheets.
  if search('<link[^>]*>')
    execute '%s/<link[^>]*>//g'
  endif

  while search('<iframe')
    execute 'normal dat'
  endwhile
  while search('<noscript')
    execute 'normal dat'
  endwhile
  while search('<script')
    execute 'normal dat'
  endwhile
  while search('<style')
    execute 'normal dat'
  endwhile
  while search('<aside')
    execute 'normal dat'
  endwhile

  " Japan Times
  while search('<div class="teads-adCall')
    execute 'normal dat'
  endwhile
  while search('div class="jt_content_ad')
    execute 'normal dat'
  endwhile

  " TODO Search for more non-ASCII with /[^\x00-\x7F]
  " Also look for <meta name="author" content="">

  execute 'g/^\s*$/d'

  if search('<title')
  endif

endfunction

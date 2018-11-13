nnoremap <leader>k :call KindleGenPrep()<CR>

function! KindleGenPrep()
  " Remove tags we know we don't want.
  " Do this first, less other regex step on tag endings.
  while search('<iframe')
    execute 'normal dat'
  endwhile
  while search('<noscript')
    execute 'normal dat'
  endwhile
  while search('<style')
    execute 'normal dat'
  endwhile
  while search('<aside')
    execute 'normal dat'
  endwhile
  while search('<figure')
    execute 'normal dat'
  endwhile
  while search('<picture')
    execute 'normal dat'
  endwhile
  " WARNING: This fails horribly against some sites, deleting everything.
  while search('<script')
    execute 'normal dat'
  endwhile

  " Handle some unicode and other oddities
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
  " These don't display properly with the current kindlegen script
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

  " TODO Search for more non-ASCII with /[^\x00-\x7F]

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
  if search(' style="[^"]*"')
    execute '%s/ style="[^"]*"//g'
  endif
  if search('<!--.\{-}-->')
    execute '%s/<!--.\{-}-->//g'
  endif
  if search('<img .\{-}>')
    execute '%s/<img .\{-}>//g'
  endif
  if search('<meta name="twitter')
    execute '%s/<meta name="twitter[^>]*>//'
  endif
  if search('<meta property="fb')
    execute '%s/<meta property="fb[^>]*>//'
  endif

  " Strip references to external stylesheets.
  if search('<link[^>]*>')
    execute '%s/<link[^>]*>//g'
  endif

  " Japan Times
  while search('<div class="teads-adCall')
    execute 'normal dat'
  endwhile
  while search('div class="jt_content_ad')
    execute 'normal dat'
  endwhile
  if search('ul class="single-sns-area"')
    execute 'normal dat'
  endif
  " Remove everything after the article body.
  if search('<div class="jtarticle_related"/')
    execute '/<div class="jtarticle_related"/,/<\/body/-d'
  endif
  if search('[あ-を]')
    execute '%s/<html.\{-}>/<html lang="ja">/'
  endif

  " New Yorker
  while search('<div class="Callout')
    execute 'normal dat'
  endwhile
  while search('<div id="RecircCarousel')
    execute 'normal dat'
  endwhile
  while search('<ul class="ArticleSocial')
    execute 'normal dat'
  endwhile
  while search('<div class="bxc')
    execute 'normal dat'
  endwhile

  " Longreads
  while search('<div class="featured-image-container">')
    execute 'normal dat'
  endwhile
  if search('<div class="member-promo slim">')
    execute 'normal dat'
  endif
  while search('<div class="in-story">')
    execute 'normal dat'
  endwhile
  while search('<div data-shortcode="caption"')
    execute 'normal dat'
  endwhile

  execute 'g/^\s*$/d'
  if search('</body')
    execute 's#</body#\r&#'
  endif

  " Risky, but almost always right. Disrespects tags, so run last.
  execute '/<body/+,/<h1/-d'

  if search('<title')
    " Just leave the focus on the <title> tag when we're done.
  endif
endfunction

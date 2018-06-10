" Run this with: vim -c "source prep.vim" file.html
:%s/“/\&ldquo;/g
:%s/”/\&rdquo;/g
:%s/‘/\&lsquo;/g
:%s/’/\&rsquo;/g
:%s/\s*—\s*/\&mdash;/g
:%s/–/\&ndash;/g
:%s/…/\&hellip;/g
:%s/à/\&agrave;/g
:%s/á/\&aacute;/g
:%s/è/\&egrave;/g
:%s/é/\&eacute;/g
:%s/ì/\&igrave;/g
:%s/í/\&iacute;/g
:%s/ò/\&ograve;/g
:%s/ó/\&oacute;/g
:%s/ù/\&ugrave;/g
:%s/ú/\&uacute;/g
:%s/À/\&Agrave;/g
:%s/Á/\&Aacute;/g
:%s/È/\&Egrave;/g
:%s/É/\&Eacute;/g
:%s/Ì/\&Igrave;/g
:%s/Í/\&Iacute;/g
:%s/Ò/\&Ograve;/g
:%s/Ó/\&Oacute;/g
:%s/Ù/\&Ugrave;/g
:%s/Ú/\&Uacute;/g
:%s/ā/\&amacr;/g
:%s/ē/\&emacr;/g
:%s/ī/\&imacr;/g
:%s/ō/\&omacr;/g
:%s/ū/\&umacr;/g
:%s/Ā/\&Amacr;/g
:%s/Ē/\&Emacr;/g
:%s/Ī/\&Imacr;/g
:%s/Ō/\&Omacr;/g
:%s/Ū/\&Umacr;/g
:%s/ç/\&ccedil;/g
:%s/<body[^>]*>/<body>\r/g
:%s/<h1 [^>]*>/\r<h1>/g
:%s/<h2 [^>]*>/\r<h2>/g
:%s/<h3 [^>]*>/\r<h3>/g
:%s/<p [^>]*>/\r<p>/g
:%s/<a [^>]*>//g
:%s#</a>##g
:%s/<link[^>]*>//g
:%s/<span[^>]*>//g
:%s#</span>##g
:%s/<meta[^>]*>/\r&/g
:%s/ / /g
:%s#<style[^>]*>.\{-}</style>##g
:%s#<script[^>]*>.\{-}</script>##g
:%s#<noscript[^>]*>.\{-}</noscript>##g
:%s#<iframe[^>]*>.\{-}</iframe>##g
:%s/ style="[^"]*"//g
" Search for more non-ASCII with /[^\x00-\x7F]
" Also look for <meta name="author" content="">

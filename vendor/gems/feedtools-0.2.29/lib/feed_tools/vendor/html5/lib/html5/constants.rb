module HTML5

  class EOF < Exception; end

  def self._(str); str end

  CONTENT_MODEL_FLAGS = [
      :PCDATA,
      :RCDATA,
      :CDATA,
      :PLAINTEXT
  ]

  SCOPING_ELEMENTS = %w[
      button
      caption
      html
      marquee
      object
      table
      td
      th
  ]

  FORMATTING_ELEMENTS = %w[
      a
      b
      big
      em
      font
      i
      nobr
      s
      small
      strike
      strong
      tt
      u
  ]

  SPECIAL_ELEMENTS = %w[
      address
      area
      base
      basefont
      bgsound
      blockquote
      body
      br
      center
      col
      colgroup
      dd
      dir
      div
      dl
      dt
      embed
      fieldset
      form
      frame
      frameset
      h1
      h2
      h3
      h4
      h5
      h6
      head
      hr
      iframe
      image
      img
      input
      isindex
      li
      link
      listing
      menu
      meta
      noembed
      noframes
      noscript
      ol
      optgroup
      option
      p
      param
      plaintext
      pre
      script
      select
      spacer
      style
      tbody
      textarea
      tfoot
      thead
      title
      tr
      ul
      wbr
  ]

  SPACE_CHARACTERS = %W[
      \t
      \n
      \x0B
      \x0C
      \x20
      \r
  ]

  TABLE_INSERT_MODE_ELEMENTS = %w[
      table
      tbody
      tfoot
      thead
      tr
  ]

  ASCII_LOWERCASE = ('a'..'z').to_a.join('')
  ASCII_UPPERCASE = ('A'..'Z').to_a.join('')
  ASCII_LETTERS = ASCII_LOWERCASE + ASCII_UPPERCASE
  DIGITS = '0'..'9'
  HEX_DIGITS = DIGITS.to_a + ('a'..'f').to_a + ('A'..'F').to_a

  # Heading elements need to be ordered 
  HEADING_ELEMENTS = %w[
      h1
      h2
      h3
      h4
      h5
      h6
  ]

  # XXX What about event-source and command?
  VOID_ELEMENTS = %w[
      base
      link
      meta
      hr
      br
      img
      embed
      param
      area
      col
      input
  ]

  CDATA_ELEMENTS = %w[title textarea]

  RCDATA_ELEMENTS = %w[
    style
    script
    xmp
    iframe
    noembed
    noframes
    noscript
  ]

  BOOLEAN_ATTRIBUTES = {
    :global    => %w[irrelevant],
    'style'    => %w[scoped],
    'img'      => %w[ismap],
    'audio'    => %w[autoplay controls],
    'video'    => %w[autoplay controls],
    'script'   => %w[defer async],
    'details'  => %w[open],
    'datagrid' => %w[multiple disabled],
    'command'  => %w[hidden disabled checked default],
    'menu'     => %w[autosubmit],
    'fieldset' => %w[disabled readonly],
    'option'   => %w[disabled readonly selected],
    'optgroup' => %w[disabled readonly],
    'button'   => %w[disabled autofocus],
    'input'    => %w[disabled readonly required autofocus checked ismap],
    'select'   => %w[disabled readonly autofocus multiple],
    'output'   => %w[disabled readonly]

  }

  # entitiesWindows1252 has to be _ordered_ and needs to have an index.
  ENTITIES_WINDOWS1252 = [
      8364,  # 0x80  0x20AC  EURO SIGN
      65533, # 0x81          UNDEFINED
      8218,  # 0x82  0x201A  SINGLE LOW-9 QUOTATION MARK
      402,   # 0x83  0x0192  LATIN SMALL LETTER F WITH HOOK
      8222,  # 0x84  0x201E  DOUBLE LOW-9 QUOTATION MARK
      8230,  # 0x85  0x2026  HORIZONTAL ELLIPSIS
      8224,  # 0x86  0x2020  DAGGER
      8225,  # 0x87  0x2021  DOUBLE DAGGER
      710,   # 0x88  0x02C6  MODIFIER LETTER CIRCUMFLEX ACCENT
      8240,  # 0x89  0x2030  PER MILLE SIGN
      352,   # 0x8A  0x0160  LATIN CAPITAL LETTER S WITH CARON
      8249,  # 0x8B  0x2039  SINGLE LEFT-POINTING ANGLE QUOTATION MARK
      338,   # 0x8C  0x0152  LATIN CAPITAL LIGATURE OE
      65533, # 0x8D          UNDEFINED
      381,   # 0x8E  0x017D  LATIN CAPITAL LETTER Z WITH CARON
      65533, # 0x8F          UNDEFINED
      65533, # 0x90          UNDEFINED
      8216,  # 0x91  0x2018  LEFT SINGLE QUOTATION MARK
      8217,  # 0x92  0x2019  RIGHT SINGLE QUOTATION MARK
      8220,  # 0x93  0x201C  LEFT DOUBLE QUOTATION MARK
      8221,  # 0x94  0x201D  RIGHT DOUBLE QUOTATION MARK
      8226,  # 0x95  0x2022  BULLET
      8211,  # 0x96  0x2013  EN DASH
      8212,  # 0x97  0x2014  EM DASH
      732,   # 0x98  0x02DC  SMALL TILDE
      8482,  # 0x99  0x2122  TRADE MARK SIGN
      353,   # 0x9A  0x0161  LATIN SMALL LETTER S WITH CARON
      8250,  # 0x9B  0x203A  SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
      339,   # 0x9C  0x0153  LATIN SMALL LIGATURE OE
      65533, # 0x9D          UNDEFINED
      382,   # 0x9E  0x017E  LATIN SMALL LETTER Z WITH CARON
      376    # 0x9F  0x0178  LATIN CAPITAL LETTER Y WITH DIAERESIS
  ]

  # ENTITIES was generated from Python using the following code:
  #
  # import constants
  # entities = constants.entities.items()
  # entities.sort()
  # list = [ ' '.join([repr(entity), '=>', ord(value)<128 and 
  #   repr(str(value)) or repr(value.encode('utf-8')).replace("'",'"')])
  #   for entity, value in entities]
  #   print '  ENTITIES = {\n    ' + ',\n    '.join(list) + '\n  }'

  ENTITIES = {
    'AElig'     => "\xc3\x86",
    'AElig;'    => "\xc3\x86",
    'AMP'       => '&',
    'AMP;'      => '&',
    'Aacute'    => "\xc3\x81",
    'Aacute;'   => "\xc3\x81",
    'Acirc'     => "\xc3\x82",
    'Acirc;'    => "\xc3\x82",
    'Agrave'    => "\xc3\x80",
    'Agrave;'   => "\xc3\x80",
    'Alpha;'    => "\xce\x91",
    'Aring'     => "\xc3\x85",
    'Aring;'    => "\xc3\x85",
    'Atilde'    => "\xc3\x83",
    'Atilde;'   => "\xc3\x83",
    'Auml'      => "\xc3\x84",
    'Auml;'     => "\xc3\x84",
    'Beta;'     => "\xce\x92",
    'COPY'      => "\xc2\xa9",
    'COPY;'     => "\xc2\xa9",
    'Ccedil'    => "\xc3\x87",
    'Ccedil;'   => "\xc3\x87",
    'Chi;'      => "\xce\xa7",
    'Dagger;'   => "\xe2\x80\xa1",
    'Delta;'    => "\xce\x94",
    'ETH'       => "\xc3\x90",
    'ETH;'      => "\xc3\x90",
    'Eacute'    => "\xc3\x89",
    'Eacute;'   => "\xc3\x89",
    'Ecirc'     => "\xc3\x8a",
    'Ecirc;'    => "\xc3\x8a",
    'Egrave'    => "\xc3\x88",
    'Egrave;'   => "\xc3\x88",
    'Epsilon;'  => "\xce\x95",
    'Eta;'      => "\xce\x97",
    'Euml'      => "\xc3\x8b",
    'Euml;'     => "\xc3\x8b",
    'GT'        => '>',
    'GT;'       => '>',
    'Gamma;'    => "\xce\x93",
    'Iacute'    => "\xc3\x8d",
    'Iacute;'   => "\xc3\x8d",
    'Icirc'     => "\xc3\x8e",
    'Icirc;'    => "\xc3\x8e",
    'Igrave'    => "\xc3\x8c",
    'Igrave;'   => "\xc3\x8c",
    'Iota;'     => "\xce\x99",
    'Iuml'      => "\xc3\x8f",
    'Iuml;'     => "\xc3\x8f",
    'Kappa;'    => "\xce\x9a",
    'LT'        => '<',
    'LT;'       => '<',
    'Lambda;'   => "\xce\x9b",
    'Mu;'       => "\xce\x9c",
    'Ntilde'    => "\xc3\x91",
    'Ntilde;'   => "\xc3\x91",
    'Nu;'       => "\xce\x9d",
    'OElig;'    => "\xc5\x92",
    'Oacute'    => "\xc3\x93",
    'Oacute;'   => "\xc3\x93",
    'Ocirc'     => "\xc3\x94",
    'Ocirc;'    => "\xc3\x94",
    'Ograve'    => "\xc3\x92",
    'Ograve;'   => "\xc3\x92",
    'Omega;'    => "\xce\xa9",
    'Omicron;'  => "\xce\x9f",
    'Oslash'    => "\xc3\x98",
    'Oslash;'   => "\xc3\x98",
    'Otilde'    => "\xc3\x95",
    'Otilde;'   => "\xc3\x95",
    'Ouml'      => "\xc3\x96",
    'Ouml;'     => "\xc3\x96",
    'Phi;'      => "\xce\xa6",
    'Pi;'       => "\xce\xa0",
    'Prime;'    => "\xe2\x80\xb3",
    'Psi;'      => "\xce\xa8",
    'QUOT'      => '"',
    'QUOT;'     => '"',
    'REG'       => "\xc2\xae",
    'REG;'      => "\xc2\xae",
    'Rho;'      => "\xce\xa1",
    'Scaron;'   => "\xc5\xa0",
    'Sigma;'    => "\xce\xa3",
    'THORN'     => "\xc3\x9e",
    'THORN;'    => "\xc3\x9e",
    'TRADE;'    => "\xe2\x84\xa2",
    'Tau;'      => "\xce\xa4",
    'Theta;'    => "\xce\x98",
    'Uacute'    => "\xc3\x9a",
    'Uacute;'   => "\xc3\x9a",
    'Ucirc'     => "\xc3\x9b",
    'Ucirc;'    => "\xc3\x9b",
    'Ugrave'    => "\xc3\x99",
    'Ugrave;'   => "\xc3\x99",
    'Upsilon;'  => "\xce\xa5",
    'Uuml'      => "\xc3\x9c",
    'Uuml;'     => "\xc3\x9c",
    'Xi;'       => "\xce\x9e",
    'Yacute'    => "\xc3\x9d",
    'Yacute;'   => "\xc3\x9d",
    'Yuml;'     => "\xc5\xb8",
    'Zeta;'     => "\xce\x96",
    'aacute'    => "\xc3\xa1",
    'aacute;'   => "\xc3\xa1",
    'acirc'     => "\xc3\xa2",
    'acirc;'    => "\xc3\xa2",
    'acute'     => "\xc2\xb4",
    'acute;'    => "\xc2\xb4",
    'aelig'     => "\xc3\xa6",
    'aelig;'    => "\xc3\xa6",
    'agrave'    => "\xc3\xa0",
    'agrave;'   => "\xc3\xa0",
    'alefsym;'  => "\xe2\x84\xb5",
    'alpha;'    => "\xce\xb1",
    'amp'       => '&',
    'amp;'      => '&',
    'and;'      => "\xe2\x88\xa7",
    'ang;'      => "\xe2\x88\xa0",
    'apos;'     => "'",
    'aring'     => "\xc3\xa5",
    'aring;'    => "\xc3\xa5",
    'asymp;'    => "\xe2\x89\x88",
    'atilde'    => "\xc3\xa3",
    'atilde;'   => "\xc3\xa3",
    'auml'      => "\xc3\xa4",
    'auml;'     => "\xc3\xa4",
    'bdquo;'    => "\xe2\x80\x9e",
    'beta;'     => "\xce\xb2",
    'brvbar'    => "\xc2\xa6",
    'brvbar;'   => "\xc2\xa6",
    'bull;'     => "\xe2\x80\xa2",
    'cap;'      => "\xe2\x88\xa9",
    'ccedil'    => "\xc3\xa7",
    'ccedil;'   => "\xc3\xa7",
    'cedil'     => "\xc2\xb8",
    'cedil;'    => "\xc2\xb8",
    'cent'      => "\xc2\xa2",
    'cent;'     => "\xc2\xa2",
    'chi;'      => "\xcf\x87",
    'circ;'     => "\xcb\x86",
    'clubs;'    => "\xe2\x99\xa3",
    'cong;'     => "\xe2\x89\x85",
    'copy'      => "\xc2\xa9",
    'copy;'     => "\xc2\xa9",
    'crarr;'    => "\xe2\x86\xb5",
    'cup;'      => "\xe2\x88\xaa",
    'curren'    => "\xc2\xa4",
    'curren;'   => "\xc2\xa4",
    'dArr;'     => "\xe2\x87\x93",
    'dagger;'   => "\xe2\x80\xa0",
    'darr;'     => "\xe2\x86\x93",
    'deg'       => "\xc2\xb0",
    'deg;'      => "\xc2\xb0",
    'delta;'    => "\xce\xb4",
    'diams;'    => "\xe2\x99\xa6",
    'divide'    => "\xc3\xb7",
    'divide;'   => "\xc3\xb7",
    'eacute'    => "\xc3\xa9",
    'eacute;'   => "\xc3\xa9",
    'ecirc'     => "\xc3\xaa",
    'ecirc;'    => "\xc3\xaa",
    'egrave'    => "\xc3\xa8",
    'egrave;'   => "\xc3\xa8",
    'empty;'    => "\xe2\x88\x85",
    'emsp;'     => "\xe2\x80\x83",
    'ensp;'     => "\xe2\x80\x82",
    'epsilon;'  => "\xce\xb5",
    'equiv;'    => "\xe2\x89\xa1",
    'eta;'      => "\xce\xb7",
    'eth'       => "\xc3\xb0",
    'eth;'      => "\xc3\xb0",
    'euml'      => "\xc3\xab",
    'euml;'     => "\xc3\xab",
    'euro;'     => "\xe2\x82\xac",
    'exist;'    => "\xe2\x88\x83",
    'fnof;'     => "\xc6\x92",
    'forall;'   => "\xe2\x88\x80",
    'frac12'    => "\xc2\xbd",
    'frac12;'   => "\xc2\xbd",
    'frac14'    => "\xc2\xbc",
    'frac14;'   => "\xc2\xbc",
    'frac34'    => "\xc2\xbe",
    'frac34;'   => "\xc2\xbe",
    'frasl;'    => "\xe2\x81\x84",
    'gamma;'    => "\xce\xb3",
    'ge;'       => "\xe2\x89\xa5",
    'gt'        => '>',
    'gt;'       => '>',
    'hArr;'     => "\xe2\x87\x94",
    'harr;'     => "\xe2\x86\x94",
    'hearts;'   => "\xe2\x99\xa5",
    'hellip;'   => "\xe2\x80\xa6",
    'iacute'    => "\xc3\xad",
    'iacute;'   => "\xc3\xad",
    'icirc'     => "\xc3\xae",
    'icirc;'    => "\xc3\xae",
    'iexcl'     => "\xc2\xa1",
    'iexcl;'    => "\xc2\xa1",
    'igrave'    => "\xc3\xac",
    'igrave;'   => "\xc3\xac",
    'image;'    => "\xe2\x84\x91",
    'infin;'    => "\xe2\x88\x9e",
    'int;'      => "\xe2\x88\xab",
    'iota;'     => "\xce\xb9",
    'iquest'    => "\xc2\xbf",
    'iquest;'   => "\xc2\xbf",
    'isin;'     => "\xe2\x88\x88",
    'iuml'      => "\xc3\xaf",
    'iuml;'     => "\xc3\xaf",
    'kappa;'    => "\xce\xba",
    'lArr;'     => "\xe2\x87\x90",
    'lambda;'   => "\xce\xbb",
    'lang;'     => "\xe3\x80\x88",
    'laquo'     => "\xc2\xab",
    'laquo;'    => "\xc2\xab",
    'larr;'     => "\xe2\x86\x90",
    'lceil;'    => "\xe2\x8c\x88",
    'ldquo;'    => "\xe2\x80\x9c",
    'le;'       => "\xe2\x89\xa4",
    'lfloor;'   => "\xe2\x8c\x8a",
    'lowast;'   => "\xe2\x88\x97",
    'loz;'      => "\xe2\x97\x8a",
    'lrm;'      => "\xe2\x80\x8e",
    'lsaquo;'   => "\xe2\x80\xb9",
    'lsquo;'    => "\xe2\x80\x98",
    'lt'        => '<',
    'lt;'       => '<',
    'macr'      => "\xc2\xaf",
    'macr;'     => "\xc2\xaf",
    'mdash;'    => "\xe2\x80\x94",
    'micro'     => "\xc2\xb5",
    'micro;'    => "\xc2\xb5",
    'middot'    => "\xc2\xb7",
    'middot;'   => "\xc2\xb7",
    'minus;'    => "\xe2\x88\x92",
    'mu;'       => "\xce\xbc",
    'nabla;'    => "\xe2\x88\x87",
    'nbsp'      => "\xc2\xa0",
    'nbsp;'     => "\xc2\xa0",
    'ndash;'    => "\xe2\x80\x93",
    'ne;'       => "\xe2\x89\xa0",
    'ni;'       => "\xe2\x88\x8b",
    'not'       => "\xc2\xac",
    'not;'      => "\xc2\xac",
    'notin;'    => "\xe2\x88\x89",
    'nsub;'     => "\xe2\x8a\x84",
    'ntilde'    => "\xc3\xb1",
    'ntilde;'   => "\xc3\xb1",
    'nu;'       => "\xce\xbd",
    'oacute'    => "\xc3\xb3",
    'oacute;'   => "\xc3\xb3",
    'ocirc'     => "\xc3\xb4",
    'ocirc;'    => "\xc3\xb4",
    'oelig;'    => "\xc5\x93",
    'ograve'    => "\xc3\xb2",
    'ograve;'   => "\xc3\xb2",
    'oline;'    => "\xe2\x80\xbe",
    'omega;'    => "\xcf\x89",
    'omicron;'  => "\xce\xbf",
    'oplus;'    => "\xe2\x8a\x95",
    'or;'       => "\xe2\x88\xa8",
    'ordf'      => "\xc2\xaa",
    'ordf;'     => "\xc2\xaa",
    'ordm'      => "\xc2\xba",
    'ordm;'     => "\xc2\xba",
    'oslash'    => "\xc3\xb8",
    'oslash;'   => "\xc3\xb8",
    'otilde'    => "\xc3\xb5",
    'otilde;'   => "\xc3\xb5",
    'otimes;'   => "\xe2\x8a\x97",
    'ouml'      => "\xc3\xb6",
    'ouml;'     => "\xc3\xb6",
    'para'      => "\xc2\xb6",
    'para;'     => "\xc2\xb6",
    'part;'     => "\xe2\x88\x82",
    'permil;'   => "\xe2\x80\xb0",
    'perp;'     => "\xe2\x8a\xa5",
    'phi;'      => "\xcf\x86",
    'pi;'       => "\xcf\x80",
    'piv;'      => "\xcf\x96",
    'plusmn'    => "\xc2\xb1",
    'plusmn;'   => "\xc2\xb1",
    'pound'     => "\xc2\xa3",
    'pound;'    => "\xc2\xa3",
    'prime;'    => "\xe2\x80\xb2",
    'prod;'     => "\xe2\x88\x8f",
    'prop;'     => "\xe2\x88\x9d",
    'psi;'      => "\xcf\x88",
    'quot'      => '"',
    'quot;'     => '"',
    'rArr;'     => "\xe2\x87\x92",
    'radic;'    => "\xe2\x88\x9a",
    'rang;'     => "\xe3\x80\x89",
    'raquo'     => "\xc2\xbb",
    'raquo;'    => "\xc2\xbb",
    'rarr;'     => "\xe2\x86\x92",
    'rceil;'    => "\xe2\x8c\x89",
    'rdquo;'    => "\xe2\x80\x9d",
    'real;'     => "\xe2\x84\x9c",
    'reg'       => "\xc2\xae",
    'reg;'      => "\xc2\xae",
    'rfloor;'   => "\xe2\x8c\x8b",
    'rho;'      => "\xcf\x81",
    'rlm;'      => "\xe2\x80\x8f",
    'rsaquo;'   => "\xe2\x80\xba",
    'rsquo;'    => "\xe2\x80\x99",
    'sbquo;'    => "\xe2\x80\x9a",
    'scaron;'   => "\xc5\xa1",
    'sdot;'     => "\xe2\x8b\x85",
    'sect'      => "\xc2\xa7",
    'sect;'     => "\xc2\xa7",
    'shy'       => "\xc2\xad",
    'shy;'      => "\xc2\xad",
    'sigma;'    => "\xcf\x83",
    'sigmaf;'   => "\xcf\x82",
    'sim;'      => "\xe2\x88\xbc",
    'spades;'   => "\xe2\x99\xa0",
    'sub;'      => "\xe2\x8a\x82",
    'sube;'     => "\xe2\x8a\x86",
    'sum;'      => "\xe2\x88\x91",
    'sup1'      => "\xc2\xb9",
    'sup1;'     => "\xc2\xb9",
    'sup2'      => "\xc2\xb2",
    'sup2;'     => "\xc2\xb2",
    'sup3'      => "\xc2\xb3",
    'sup3;'     => "\xc2\xb3",
    'sup;'      => "\xe2\x8a\x83",
    'supe;'     => "\xe2\x8a\x87",
    'szlig'     => "\xc3\x9f",
    'szlig;'    => "\xc3\x9f",
    'tau;'      => "\xcf\x84",
    'there4;'   => "\xe2\x88\xb4",
    'theta;'    => "\xce\xb8",
    'thetasym;' => "\xcf\x91",
    'thinsp;'   => "\xe2\x80\x89",
    'thorn'     => "\xc3\xbe",
    'thorn;'    => "\xc3\xbe",
    'tilde;'    => "\xcb\x9c",
    'times'     => "\xc3\x97",
    'times;'    => "\xc3\x97",
    'trade;'    => "\xe2\x84\xa2",
    'uArr;'     => "\xe2\x87\x91",
    'uacute'    => "\xc3\xba",
    'uacute;'   => "\xc3\xba",
    'uarr;'     => "\xe2\x86\x91",
    'ucirc'     => "\xc3\xbb",
    'ucirc;'    => "\xc3\xbb",
    'ugrave'    => "\xc3\xb9",
    'ugrave;'   => "\xc3\xb9",
    'uml'       => "\xc2\xa8",
    'uml;'      => "\xc2\xa8",
    'upsih;'    => "\xcf\x92",
    'upsilon;'  => "\xcf\x85",
    'uuml'      => "\xc3\xbc",
    'uuml;'     => "\xc3\xbc",
    'weierp;'   => "\xe2\x84\x98",
    'xi;'       => "\xce\xbe",
    'yacute'    => "\xc3\xbd",
    'yacute;'   => "\xc3\xbd",
    'yen'       => "\xc2\xa5",
    'yen;'      => "\xc2\xa5",
    'yuml'      => "\xc3\xbf",
    'yuml;'     => "\xc3\xbf",
    'zeta;'     => "\xce\xb6",
    'zwj;'      => "\xe2\x80\x8d",
    'zwnj;'     => "\xe2\x80\x8c"
  }

  ENCODINGS = %w[
      ansi_x3.4-1968
      iso-ir-6
      ansi_x3.4-1986
      iso_646.irv:1991
      ascii
      iso646-us
      us-ascii
      us
      ibm367
      cp367
      csascii
      ks_c_5601-1987
      korean
      iso-2022-kr
      csiso2022kr
      euc-kr
      iso-2022-jp
      csiso2022jp
      iso-2022-jp-2
      iso-ir-58
      chinese
      csiso58gb231280
      iso_8859-1:1987
      iso-ir-100
      iso_8859-1
      iso-8859-1
      latin1
      l1
      ibm819
      cp819
      csisolatin1
      iso_8859-2:1987
      iso-ir-101
      iso_8859-2
      iso-8859-2
      latin2
      l2
      csisolatin2
      iso_8859-3:1988
      iso-ir-109
      iso_8859-3
      iso-8859-3
      latin3
      l3
      csisolatin3
      iso_8859-4:1988
      iso-ir-110
      iso_8859-4
      iso-8859-4
      latin4
      l4
      csisolatin4
      iso_8859-6:1987
      iso-ir-127
      iso_8859-6
      iso-8859-6
      ecma-114
      asmo-708
      arabic
      csisolatinarabic
      iso_8859-7:1987
      iso-ir-126
      iso_8859-7
      iso-8859-7
      elot_928
      ecma-118
      greek
      greek8
      csisolatingreek
      iso_8859-8:1988
      iso-ir-138
      iso_8859-8
      iso-8859-8
      hebrew
      csisolatinhebrew
      iso_8859-5:1988
      iso-ir-144
      iso_8859-5
      iso-8859-5
      cyrillic
      csisolatincyrillic
      iso_8859-9:1989
      iso-ir-148
      iso_8859-9
      iso-8859-9
      latin5
      l5
      csisolatin5
      iso-8859-10
      iso-ir-157
      l6
      iso_8859-10:1992
      csisolatin6
      latin6
      hp-roman8
      roman8
      r8
      ibm037
      cp037
      csibm037
      ibm424
      cp424
      csibm424
      ibm437
      cp437
      437
      cspc8codepage437
      ibm500
      cp500
      csibm500
      ibm775
      cp775
      cspc775baltic
      ibm850
      cp850
      850
      cspc850multilingual
      ibm852
      cp852
      852
      cspcp852
      ibm855
      cp855
      855
      csibm855
      ibm857
      cp857
      857
      csibm857
      ibm860
      cp860
      860
      csibm860
      ibm861
      cp861
      861
      cp-is
      csibm861
      ibm862
      cp862
      862
      cspc862latinhebrew
      ibm863
      cp863
      863
      csibm863
      ibm864
      cp864
      csibm864
      ibm865
      cp865
      865
      csibm865
      ibm866
      cp866
      866
      csibm866
      ibm869
      cp869
      869
      cp-gr
      csibm869
      ibm1026
      cp1026
      csibm1026
      koi8-r
      cskoi8r
      koi8-u
      big5-hkscs
      ptcp154
      csptcp154
      pt154
      cp154
      utf-7
      utf-16be
      utf-16le
      utf-16
      utf-8
      iso-8859-13
      iso-8859-14
      iso-ir-199
      iso_8859-14:1998
      iso_8859-14
      latin8
      iso-celtic
      l8
      iso-8859-15
      iso_8859-15
      iso-8859-16
      iso-ir-226
      iso_8859-16:2001
      iso_8859-16
      latin10
      l10
      gbk
      cp936
      ms936
      gb18030
      shift_jis
      ms_kanji
      csshiftjis
      euc-jp
      gb2312
      big5
      csbig5
      windows-1250
      windows-1251
      windows-1252
      windows-1253
      windows-1254
      windows-1255
      windows-1256
      windows-1257
      windows-1258
      tis-620
      hz-gb-2312
  ]

  E = {
      "null-character" =>
         _("Null character in input stream, replaced with U+FFFD."),
      "incorrectly-placed-solidus" =>
         _("Solidus (/) incorrectly placed in tag."),
      "incorrect-cr-newline-entity" =>
         _("Incorrect CR newline entity, replaced with LF."),
      "illegal-windows-1252-entity" =>
         _("Entity used with illegal number (windows-1252 reference)."),
      "cant-convert-numeric-entity" =>
         _("Numeric entity couldn't be converted to character " +
           "(codepoint U+%(charAsInt)08x)."),
      "illegal-codepoint-for-numeric-entity" =>
         _("Numeric entity represents an illegal codepoint=> " +
           "U+%(charAsInt)08x."),
      "numeric-entity-without-semicolon" =>
         _("Numeric entity didn't end with ';'."),
      "expected-numeric-entity-but-got-eof" =>
         _("Numeric entity expected. Got end of file instead."),
      "expected-numeric-entity" =>
         _("Numeric entity expected but none found."),
      "named-entity-without-semicolon" =>
         _("Named entity didn't end with ';'."),
      "expected-named-entity" =>
         _("Named entity expected. Got none."),
      "attributes-in-end-tag" =>
         _("End tag contains unexpected attributes."),
      "expected-tag-name-but-got-right-bracket" =>
         _("Expected tag name. Got '>' instead."),
      "expected-tag-name-but-got-question-mark" =>
         _("Expected tag name. Got '?' instead. (HTML doesn't " +
           "support processing instructions.)"),
      "expected-tag-name" =>
         _("Expected tag name. Got something else instead"),
      "expected-closing-tag-but-got-right-bracket" =>
         _("Expected closing tag. Got '>' instead. Ignoring '</>'."),
      "expected-closing-tag-but-got-eof" =>
         _("Expected closing tag. Unexpected end of file."),
      "expected-closing-tag-but-got-char" =>
         _("Expected closing tag. Unexpected character '%(data)' found."),
      "eof-in-tag-name" =>
         _("Unexpected end of file in the tag name."),
      "expected-attribute-name-but-got-eof" =>
         _("Unexpected end of file. Expected attribute name instead."),
      "eof-in-attribute-name" =>
         _("Unexpected end of file in attribute name."),
      "duplicate-attribute" =>
         _("Dropped duplicate attribute on tag."),
      "expected-end-of-tag-name-but-got-eof" =>
         _("Unexpected end of file. Expected = or end of tag."),
      "expected-attribute-value-but-got-eof" =>
         _("Unexpected end of file. Expected attribute value."),
      "eof-in-attribute-value-double-quote" =>
         _("Unexpected end of file in attribute value (\")."),
      "eof-in-attribute-value-single-quote" =>
         _("Unexpected end of file in attribute value (')."),
      "eof-in-attribute-value-no-quotes" =>
         _("Unexpected end of file in attribute value."),
      "expected-dashes-or-doctype" =>
         _("Expected '--' or 'DOCTYPE'. Not found."),
      "incorrect-comment" =>
         _("Incorrect comment."),
      "eof-in-comment" =>
         _("Unexpected end of file in comment."),
      "eof-in-comment-end-dash" =>
         _("Unexpected end of file in comment (-)"),
      "unexpected-dash-after-double-dash-in-comment" =>
         _("Unexpected '-' after '--' found in comment."),
      "eof-in-comment-double-dash" =>
         _("Unexpected end of file in comment (--)."),
      "unexpected-char-in-comment" =>
         _("Unexpected character in comment found."),
      "need-space-after-doctype" =>
         _("No space after literal string 'DOCTYPE'."),
      "expected-doctype-name-but-got-right-bracket" =>
         _("Unexpected > character. Expected DOCTYPE name."),
      "expected-doctype-name-but-got-eof" =>
         _("Unexpected end of file. Expected DOCTYPE name."),
      "eof-in-doctype-name" =>
         _("Unexpected end of file in DOCTYPE name."),
      "eof-in-doctype" =>
         _("Unexpected end of file in DOCTYPE."),
      "expected-space-or-right-bracket-in-doctype" =>
         _("Expected space or '>'. Got '%(data)'"),
      "unexpected-end-of-doctype" =>
         _("Unexpected end of DOCTYPE."),
      "unexpected-char-in-doctype" =>
         _("Unexpected character in DOCTYPE."),
      "eof-in-bogus-doctype" =>
         _("Unexpected end of file in bogus doctype."),
      "eof-in-innerhtml" =>
         _("XXX innerHTML EOF"),
      "unexpected-doctype" =>
         _("Unexpected DOCTYPE. Ignored."),
      "non-html-root" =>
         _("html needs to be the first start tag."),
      "expected-doctype-but-got-eof" =>
         _("Unexpected End of file. Expected DOCTYPE."),
      "unknown-doctype" =>
         _("Erroneous DOCTYPE."),
      "expected-doctype-but-got-chars" =>
         _("Unexpected non-space characters. Expected DOCTYPE."),
      "expected-doctype-but-got-start-tag" =>
         _("Unexpected start tag (%(name)). Expected DOCTYPE."),
      "expected-doctype-but-got-end-tag" =>
         _("Unexpected end tag (%(name)). Expected DOCTYPE."),
      "end-tag-after-implied-root" =>
         _("Unexpected end tag (%(name)) after the (implied) root element."),
      "expected-named-closing-tag-but-got-eof" =>
         _("Unexpected end of file. Expected end tag (%(name))."),
      "two-heads-are-not-better-than-one" =>
         _("Unexpected start tag head in existing head. Ignored."),
      "unexpected-end-tag" =>
         _("Unexpected end tag (%(name)). Ignored."),
      "unexpected-start-tag-out-of-my-head" =>
         _("Unexpected start tag (%(name)) that can be in head. Moved."),
      "unexpected-start-tag" =>
         _("Unexpected start tag (%(name))."),
      "missing-end-tag" =>
         _("Missing end tag (%(name))."),
      "missing-end-tags" =>
         _("Missing end tags (%(name))."),
      "unexpected-start-tag-implies-end-tag" =>
         _("Unexpected start tag (%(startName)) " +
           "implies end tag (%(endName))."),
      "unexpected-start-tag-treated-as" =>
         _("Unexpected start tag (%(originalName)). Treated as %(newName)."),
      "deprecated-tag" =>
         _("Unexpected start tag %(name). Don't use it!"),
      "unexpected-start-tag-ignored" =>
         _("Unexpected start tag %(name). Ignored."),
      "expected-one-end-tag-but-got-another" =>
         _("Unexpected end tag (%(gotName)). " +
           "Missing end tag (%(expectedName))."),
      "end-tag-too-early" =>
         _("End tag (%(name)) seen too early. Expected other end tag."),
      "end-tag-too-early-named" =>
         _("Unexpected end tag (%(gotName)). Expected end tag (%(expectedName))."),
      "end-tag-too-early-ignored" =>
         _("End tag (%(name)) seen too early. Ignored."),
      "adoption-agency-1.1" =>
         _("End tag (%(name)) violates step 1, " +
           "paragraph 1 of the adoption agency algorithm."),
      "adoption-agency-1.2" =>
         _("End tag (%(name)) violates step 1, " +
           "paragraph 2 of the adoption agency algorithm."),
      "adoption-agency-1.3" =>
         _("End tag (%(name)) violates step 1, " +
           "paragraph 3 of the adoption agency algorithm."),
      "unexpected-end-tag-treated-as" =>
         _("Unexpected end tag (%(originalName)). Treated as %(newName)."),
      "no-end-tag" =>
         _("This element (%(name)) has no end tag."),
      "unexpected-implied-end-tag-in-table" =>
         _("Unexpected implied end tag (%(name)) in the table phase."),
      "unexpected-implied-end-tag-in-table-body" =>
         _("Unexpected implied end tag (%(name)) in the table body phase."),
      "unexpected-char-implies-table-voodoo" =>
         _("Unexpected non-space characters in " +
           "table context caused voodoo mode."),
      "unexpected-start-tag-implies-table-voodoo" =>
         _("Unexpected start tag (%(name)) in " +
           "table context caused voodoo mode."),
      "unexpected-end-tag-implies-table-voodoo" =>
         _("Unexpected end tag (%(name)) in " +
           "table context caused voodoo mode."),
      "unexpected-cell-in-table-body" =>
         _("Unexpected table cell start tag (%(name)) " +
           "in the table body phase."),
      "unexpected-cell-end-tag" =>
         _("Got table cell end tag (%(name)) " +
           "while required end tags are missing."),
      "unexpected-end-tag-in-table-body" =>
         _("Unexpected end tag (%(name)) in the table body phase. Ignored."),
      "unexpected-implied-end-tag-in-table-row" =>
         _("Unexpected implied end tag (%(name)) in the table row phase."),
      "unexpected-end-tag-in-table-row" =>
         _("Unexpected end tag (%(name)) in the table row phase. Ignored."),
      "unexpected-select-in-select" =>
         _("Unexpected select start tag in the select phase " +
           "implies select start tag."),
      "unexpected-start-tag-in-select" =>
         _("Unexpected start tag token (%(name) in the select phase. " +
           "Ignored."),
      "unexpected-end-tag-in-select" =>
         _("Unexpected end tag (%(name)) in the select phase. Ignored."),
      "unexpected-char-after-body" =>
         _("Unexpected non-space characters in the after body phase."),
      "unexpected-start-tag-after-body" =>
         _("Unexpected start tag token (%(name))" +
           " in the after body phase."),
      "unexpected-end-tag-after-body" =>
         _("Unexpected end tag token (%(name))" +
           " in the after body phase."),
      "unexpected-char-in-frameset" =>
         _("Unepxected characters in the frameset phase. Characters ignored."),
      "unexpected-start-tag-in-frameset" =>
         _("Unexpected start tag token (%(name))" +
           " in the frameset phase. Ignored."),
      "unexpected-frameset-in-frameset-innerhtml" =>
         _("Unexpected end tag token (frameset) " +
           "in the frameset phase (innerHTML)."),
      "unexpected-end-tag-in-frameset" =>
         _("Unexpected end tag token (%(name))" +
           " in the frameset phase. Ignored."),
      "unexpected-char-after-frameset" =>
         _("Unexpected non-space characters in the " +
           "after frameset phase. Ignored."),
      "unexpected-start-tag-after-frameset" =>
         _("Unexpected start tag (%(name))" +
           " in the after frameset phase. Ignored."),
      "unexpected-end-tag-after-frameset" =>
         _("Unexpected end tag (%(name))" +
           " in the after frameset phase. Ignored."),
      "expected-eof-but-got-char" =>
         _("Unexpected non-space characters. Expected end of file."),
      "expected-eof-but-got-start-tag" =>
         _("Unexpected start tag (%(name))" +
           ". Expected end of file."),
      "expected-eof-but-got-end-tag" =>
         _("Unexpected end tag (%(name))" +
           ". Expected end of file."),
      "unexpected-end-table-in-caption" =>
        _("Unexpected end table tag in caption. Generates implied end caption.")
  }

end

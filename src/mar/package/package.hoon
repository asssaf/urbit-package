::
::::  /hoon/package/package/mar
  ::
/-  package
/+  httr-to-json
!:
|_  pack/package:package
++  grab
  |%
  ++  noun  package:package
  ++  httr  (cork httr-to-json json)
  ++  json
    =<  |=(jon/^json (need (package-parser jon)))
    |%
    ++  purl-parser
      =+  dejs-soft:format
      (ci |=(a/@t (de-purl:html a)) so)
    ::
    ++  hash-parser
      =+  dejs-soft:format
      (ci |=(a/@t (slaw %uv a)) so)
    ++  rels-parser
      =+  dejs-soft:format
      (ar (cu |=(a/@t (stab a)) so))
    ::
    ++  union-parser
      =+  dejs-soft:format
      |*  options/mold
      |*  {selector/@t parser/$-(options fist)}
      |=  jon/json
      %+  biff  ((ot selector^so ~) jon)
      |=  type/@t
      ?.  ?=(options type)
        ~
      ((parser type) jon)
    ::
    ++  item-parser
      =+  dejs-soft:format
      =+  options=?($package $fileset)
      %+  (union-parser options)
        'type'
      |=  type/options
      ?-  type
        $package  (pe %package (ot url+purl-parser ~))
        $fileset  (pe %fileset (ot base+purl-parser rels+rels-parser ~))
      ==
    ::
    ++  package-parser
      =+  dejs-soft:format
      (ot name+so hash+hash-parser items+(ar item-parser) ~)
    --
  --
--

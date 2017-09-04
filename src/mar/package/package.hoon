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
      =+  jo
      (cu |=(a/@t (need (epur a))) so)
    ::
    ++  rels-parser
      =+  jo
      (ar (cu |=(a/@t (stab a)) so))
    ::
    ++  union-parser
      =+  jo
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
      =+  jo
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
      =+  jo
      (ot name+so items+(ar item-parser) ~)
    --
  --
--

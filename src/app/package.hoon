::
::::  /hoon/package/app
  ::
/-  package
!:
|%
++  move  {bone card}
++  card
  $%  {$info wire @p toro}
      {$hiss wire $~ mark {$purl purl}}
  ==
++  action
  $%  {$install d/desk p/package-item:package}
  ==
++  state
  $~
--
::
|_  {hid/bowl state}
::++  prep  _`.
::
++  poke-noun
  |=  a/action
  ^-  (quip move +>)
  ?-  a
  {$install *}
    :_  +>.$
    (install-package-item +.a)
  ==
::
++  install-package-item
  |=  {d/desk pack/package-item:package}
  ^-  (list move)
  =+  way=/install/package/[d]
  [(fetch-url way %package-package pack) ~]
::
++  install-package
  |=  {d/desk pack/package:package}
  ^-  (quip move +>)
  :_  +>.$
  %-  zing
  %+  turn  items.pack
  |=  it/item:package
  ?-  it
  {$fileset *}
    %+  fetch-fileset
      /install/file/[d]/[name.pack]
    +.it
  {$package *}
    %+  install-package-item
      d
    +.it
  ==
::
++  install-file
  |=  {d/desk pname/@tas pax/path mim/mime}
  ~&  [%writing desk=d pname=pname pax=pax]
  (write-file d pax mim)
::
++  write-file
  |=  {d/desk pax/path mim/mime}
  ^-  (quip move +>)
  =+  deskroot=`path`/[(scot %p our.hid)]/[d]/[(scot %da now.hid)]
  =+  fullpath=(weld deskroot pax)
  =+  wr=(foal fullpath [%mime !>(mim)])
  :_  +>.$
  [ost.hid %info /writing our.hid wr]~
::
++  fetch-fileset
  |=  {way/wire fs/fileset-item:package}
  ^-  (list move)
  %+  turn  rels.fs
  |=  pax/path
  %^    fetch-url
      (weld way pax)
    %httr
  (extend-url base.fs pax)
::
++  extend-url
  |=  {url/purl pax/path}
  =+  rev=(flop pax)
  ~!  rev=rev
  =+  revbase=+>.rev
  =+  file=(rap 3 +<.rev '.' -.rev ~)
  =+  new=(flop [i=file t=revbase])
  url(q.q (weld q.q.url new))
::
++  fetch-url
  |=  {way/wire mar/mark url/purl}
  ^-  move
  ~&  [%fetching url=(earn url)]
  [ost.hid %hiss way ~ mar [%purl url]]
::
++  sigh-package-package
  |=  {way/wire pack/package:package}
  =+  desk=(snag 2 way)
  (install-package desk pack)
::
++  sigh-httr
  |=  {way/wire res/httr}
  ^-  (quip move +>)
  ~|  res
  ?>  =(2 (div p.res 100))
  ?.  =(/install/file (scag 2 way))
    ~|  [%unexpected-wire way=way]
    !!
  =+  desk=(snag 2 way)
  (install-file desk (snag 3 way) (slag 4 way) [/application/octet-stream (need r.res)])
::
++  sigh-tang
  |=  {way/wire tan/tang}
  ^-  (quip move +>)
  %-  (slog >%talk-sigh-tang< tan)
  [~ +>.$]
--

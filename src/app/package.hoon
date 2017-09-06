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
  $%  {$installed d/desk}
      {$install d/desk p/package-item:package}
      {$uninstall d/desk p/pname}
      {$verify d/desk p/pname}
      {$contents d/desk p/pname}
      {$belongs d/desk pax/path}
  ==
++  pname  @tas
++  installed-package
  $:  name/@tas
      files/(map path installed-file)
  ==
++  installed-file
  {pax/path has/@ux}
++  installed-file-state
  $%  {$verified $~}
      {$missing $~}
      {$modified cur/@ux}
  ==
++  state
  $:  $0
      side/(map desk desk-state)
  ==
++  desk-state
  $:  packages/(map pname installed-package)
      files/(map path pname)
  ==
--
::
|_  {hid/bowl state}
::++  prep  _`.
::
++  poke-noun
  |=  a/action
  ^-  (quip move +>)
  ?>  (team our.hid src.hid)      :: don't allow strangers
  ?-  a
    {$installed *}  (list-packages +.a)
    {$contents *}  (list-package-contents +.a)
    {$belongs *}  (belongs +.a)
    {$verify *}  (verify-package +.a)
    {$install *}  [(install-package-item +.a) +>.$]
    {$uninstall *}  (uninstall-package +.a)
  ==
::
++  list-packages
  |=  syd/desk
  ~&  (installed-packages syd)
  [~ +>.$]
::
++  installed-packages
  |=  syd/desk
  %+  biff  (~(get by side) syd)
  |=  ds/desk-state
  ~(key by packages.ds)
::
++  is-package-installed
  |=  {syd/desk pan/pname}
  (~(has in (installed-packages syd)) pan)
::
++  list-package-contents
  |=  {syd/desk pan/pname}
  :_  +>.$
  %+  biff  (~(get by side) syd)
  |=  ds/desk-state
  %+  biff  (~(get by packages.ds) pan)
  |=  pin/installed-package
  ~&  ~(val by files.pin)
  ~
::
++  belongs
  |=  {syd/desk pax/path}
  :_  +>.$
  %+  biff  (~(get by side) syd)
  |=  ds/desk-state
  ~&  (~(get by files.ds) pax)
  ~
::
++  verify-package
  |=  {syd/desk pan/pname}
  :_  +>.$
  %+  murn  (verify-files syd pan)
  |=  {f/installed-file s/installed-file-state}
  ~&  [-.s pax.f]
  ~
::
++  verify-files
  |=  {syd/desk pan/pname}
  %+  biff  (~(get by side) syd)
  |=  ds/desk-state
  %+  biff  (~(get by packages.ds) pan)
  |=  pin/installed-package
  %+  turn  ~(val by files.pin)
  |=  f/installed-file
  [f=f s=(verify-file syd f)]
::
++  verify-file
  |=  {syd/desk f/installed-file}
  ^-  installed-file-state
  =+  cot=(file (relpath-to-abs syd pax.f))
  ?~  cot
    [%missing ~]
  ?>  ?=(@ u.cot)
  ?.  =(has.f (shax u.cot))
    [%modified cur=(shax u.cot)]
  [%verified ~]
::
++  uninstall-package
  |=  {syd/desk pan/pname}
  ^-  (quip move +>)
  ?.  (is-package-installed syd pan)
    ~&  [%package-is-not-installed pan]
    [~ +>.$]
  =+  ds=(~(got by side) syd)
  =/  ds
  %_  ds
    packages  (~(del by packages.ds) pan)
    files
      %-  malt
      %+  skip  (~(tap by files.ds) ~)
      |=  {pax/path p/pname}
      =(pan p)
  ==
  :_  +>.$(side (~(put by side) syd ds))
  =+  file-states=(verify-files syd pan)
  =/  modified
  %+  skim  file-states
  |=  {f/installed-file s/installed-file-state}
  =+  m=?=($modified -.s)
  ~?  m  [-.s pax.f]
  m
  ?.  =((lent modified) 0)
    ~&  %remove-modified-files-manually
    ~
  :_  ~
  :*  ost.hid
      %info
      /uninstall/[pan]
      our.hid
      syd
      %&
      %+  murn  file-states
      |=  {f/installed-file s/installed-file-state}
      ?.  ?=($verified -.s)
        ~
      %-  some
      [pax.f [%del ~]]
  ==
::
++  install-package-item
  |=  {syd/desk pack/package-item:package}
  ^-  (list move)
  =+  way=/install/package/[syd]
  [(fetch-url way %package-package pack) ~]
::
++  install-package
  |=  {syd/desk pack/package:package}
  ^-  (quip move +>)
  :_  +>.$
  ?:  (is-package-installed syd name.pack)
    ~&  [%package-already-installed name.pack]
    ~
  :: check if there are existing files in the way
  =/  conflicts
  %+  murn
  ^-  (list path)
  %-  zing
  ^-  (list (list path))
  %+  murn  items.pack
  |=  it/item:package
  ?.  ?=($fileset -.it)
    ~
  (some rels.it)
  |=  pax/path
  =+  marpax=(ext-to-mark pax)
  ?~  (file (relpath-to-abs syd marpax))
    ~
  ~&  [%conflict pax=marpax]
  (some pax)
  ?.  =((lent conflicts) 0)
    ~&  %move-files-manually
    ~
  :: no conflicts - go ahead and install
  %-  zing
  %+  turn  items.pack
  |=  it/item:package
  ?-  it
  {$fileset *}
    %+  fetch-fileset
      /install/file/[syd]/[name.pack]
    +.it
  {$package *}
    %+  install-package-item
      syd
    +.it
  ==
::
++  install-file
  |=  {syd/desk pan/pname pax/path mim/mime}
  ~&  [%writing desk=syd pname=pan pax=pax]
  :-  (write-file syd pax mim)
  =+  ds=(fall (~(get by side) syd) *desk-state)
  =+  pin=(fall (~(get by packages.ds) pan) [pan files=~])
  =+  f=[pax (shax q.q.mim)]
  =+  files=(~(put by files.pin) pax f)
  =.  side
  %+  ~(put by side)  syd
  %=  ds
    packages  (~(put by packages.ds) pan pin(files files))
    files  (~(put by files.ds) pax pan)
  ==
  +>.$
::
++  write-file
  |=  {syd/desk pax/path mim/mime}
  ^-  (list move)
  =+  wr=(foal (relpath-to-abs syd pax) [%mime !>(mim)])
  [ost.hid %info /writing our.hid wr]~
::
++  fetch-fileset
  |=  {way/wire fs/fileset-item:package}
  ^-  (list move)
  %+  turn  rels.fs
  |=  pax/path
  %^    fetch-url
      (weld way (ext-to-mark pax))
    %httr
  (extend-url base.fs pax)
::
++  extend-url
  |=  {url/purl pax/path}
  (scan "{(earn url)}{(spud pax)}" auri:epur)
::
++  ext-to-mark
  |=  pax/path
  ^-  path
  =+  revpax=(flop pax)
  ?>  ?=(^ revpax)
  =+  [last rest]=revpax
  =+  rev=(flop (rip 3 last))
  =+  r=rev
  =+  i=0
  =/  j
  |-
    ?~  r
      i
    ?:  =(-.r '.')
      i
    $(i +(i), r +.r)
  =+  mar=(rep 3 (flop (scag j rev)))
  =+  fil=(rep 3 (flop (slag +(j) rev)))
  (flop [i=mar [t=[i=fil t=rest]]])
::
++  fetch-url
  |=  {way/wire mar/mark url/purl}
  ^-  move
  ~&  [%fetching url=(earn url)]
  [ost.hid %hiss way ~ mar [%purl url]]
::
++  base
  |=  syd/desk
  ^-  path
  /[(scot %p our.hid)]/[syd]/[(scot %da now.hid)]
::
++  relpath-to-abs
  |=  {syd/desk pax/path}
  (weld (base syd) pax)
::
++  sigh-package-package
  |=  {way/wire pack/package:package}
  =+  syd=(snag 2 way)
  (install-package syd pack)
::
++  sigh-httr
  |=  {way/wire res/httr}
  ^-  (quip move +>)
  ~|  res
  ?>  =(2 (div p.res 100))
  ?.  =(/install/file (scag 2 way))
    ~|  [%unexpected-wire way=way]
    !!
  =+  syd=(snag 2 way)
  (install-file syd (snag 3 way) (slag 4 way) [/application/octet-stream (need r.res)])
::
++  sigh-tang
  |=  {way/wire tan/tang}
  ^-  (quip move +>)
  %-  (slog >%talk-sigh-tang< tan)
  [~ +>.$]
--

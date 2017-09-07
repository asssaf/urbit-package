::
::::  /hoon/package/app
  ::
/-  package
/+  package-promise
[package-promise .]
!:
|%
++  move  {bone card}
++  card
  $%  {$info wire @p toro}
      {$poke wire {@p $package} $package-action action:package}
      {$hiss wire $~ mark {$purl purl}}
  ==
++  pname  pname:package
++  installed-package
  $:  name/pname
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
++  queue-package
  $%  {$& package:package}           :: package waiting for dependencies
      {$| package-item:package}      :: dependency url
  ==
++  desk-state
  $:  packages/(map pname installed-package)   :: files by package
      files/(map path pname)                   :: file to owning package
      queue/(list queue-package)               :: package install queue
      work/(map pname (promise mime))          :: per-package pending work
  ==
--
::
|_  {hid/bowl state}
::++  prep  _`.
::
++  poke-noun
  |=  a/*
  ^-  (quip move +>)
  %-  poke-package-action
  ~|  [%strange-action a]
  ;;(action:package a)
::
++  poke-package-action
  |=  a/action:package
  ^-  (quip move +>)
  ?>  (team our.hid src.hid)      :: don't allow strangers
  ?-  a
    {$installed *}  (list-packages +.a)
    {$contents *}  (list-package-contents +.a)
    {$belongs *}  (belongs +.a)
    {$verify *}  (verify-package +.a)
    {$install *}  (install-package-item +.a)
    {$uninstall *}  (uninstall-package +.a)
    {$resume *}  (install-next-package +.a)
    {$help *}  (help +.a)
  ==
::
++  help
  |=  a/@tas
  ^-  (quip move +>)
  =+  h=(~(get by action-help:package) a)
  ~&  ?~  h  action-help:package  [a u.h]
  [~ +>.$]
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
  :_  +>.$(side (remove-package-from-desk-state syd pan))
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
      %+  delete-files
        syd
      %+  murn  file-states
      |=  {f/installed-file s/installed-file-state}
      ?.  ?=($verified -.s)
        ~
      (some pax.f)
  ==
::
++  remove-package-from-desk-state
  |=  {syd/desk pan/pname}
  =+  ds=(~(got by side) syd)
  %+  ~(put by side)  syd
  %_  ds
    packages  (~(del by packages.ds) pan)
    files
      %-  malt
      %+  skip  (~(tap by files.ds) ~)
      |=  {pax/path p/pname}
      =(pan p)
  ==
::
++  delete-files
  |=  {syd/desk paths/(list path)}
  ^-  toro
  :*  syd
      %&
      %+  turn  paths
      |=  pax/path
      [pax [%del ~]]
  ==
::
++  install-package-item
  |=  {syd/desk pack/package-item:package}
  ^-  (quip move +>)
  (install-package-items syd [%| pack]~)
::
++  install-package-items
  |=  {syd/desk packs/(list queue-package)}
  ^-  (quip move +>)
  =+  ds=(fall (~(get by side) syd) *desk-state)
  =.  side
  %+  ~(put by side)  syd
  ds(queue (weld packs queue.ds))
  (install-next-package syd)
::
++  install-next-package
  |=  syd/desk
  ^-  (quip move +>)
  =+  ds=(~(get by side) syd)
  ?~  ds
    [~ +>.$]
  ?~  queue.u.ds
    [~ +>.$]
  =+  qp=-.queue.u.ds
  ?-  qp
  {$& *}
    :: a package that was waiting for its dependencies
    :: since it's at the top of the queue we can install it now
    (install-package syd +.qp)
  {$| *}
    :: remove from queue and fetch
    =.  side  (pop-package-queue syd)
    =+  way=/install/package/[syd]
    :_  +>.$
    [(fetch-url way %package-package +.qp)]~
  ==
::
++  pop-package-queue
  |=  syd/desk
  =+  ds=(~(got by side) syd)
  %+  ~(put by side)
    syd
  ds(queue +.queue.ds)
::
++  install-package-dependencies
  |=  {syd/desk pack/package:package}
  ^-  (quip move +>)
  ~&  [%checking-prerequities for=name.pack]
  =/  package-items
  ^-  (list package-item:package)
  %+  murn  items.pack
  |=  it/item:package
  ?+  it  ~
  {$package *}  (some +.it)
  ==
  ?:  =(~ package-items)
    :: no dependencies, move on to the next item in the queue
    (install-next-package syd)
  :: insert the dependencies to the queue
  %+  install-package-items  syd
  %+  turn  package-items
  |=  {p/package-item:package}
  [%| p]
::
:: install a package that has its dependencies installed already
++  install-package
  |=  {syd/desk pack/package:package}
  ^-  (quip move +>)
  =+  ds=(~(got by side) syd)
  :: check that the package is not already pending
  ?:  (~(has by work.ds) name.pack)
    ~&  [%package-already-pending name.pack]
    [~ +>.$]
  :: check that the package is not already installed
  ?:  (is-package-installed syd name.pack)
    ~&  [%package-already-installed name.pack]
    :: remove from queue and resume
    =.  side  (pop-package-queue syd)
    (install-next-package syd)
  (install-package-files syd pack)
::
++  install-package-files
  |=  {syd/desk pack/package:package}
  ~&  [%installing name.pack]
  :: get paths from all filesets
  =/  paths
  ^-  (list path)
  %-  zing
  ^-  (list (list path))
  %+  murn  items.pack
  |=  it/item:package
  ?.  ?=($fileset -.it)
    ~
  %-  some
  %+  turn  rels.it
  |=  pax/path
  (ext-to-mark pax)
  :: check if there are existing files in the way
  =/  conflicts
  %+  murn  paths
  |=  pax/path
  ?~  (file (relpath-to-abs syd pax))
    ~
  ~&  [%conflict pax=pax]
  (some pax)
  ?.  =((lent conflicts) 0)
    ~&  %move-files-manually
    [~ +>.$]
  :: no conflicts - go ahead and install
  =.  side  (register-work syd name.pack paths)
  :_  +>.$
  %-  zing
  ^-  (list (list move))
  %+  murn  items.pack
  |=  it/item:package
  ?.  ?=($fileset -.it)
    ~
  %-  some
  %+  fetch-fileset
    /install/file/[syd]/[name.pack]
  +.it
::
++  register-work
  |=  {syd/desk pan/pname paths/(list path)}
  =+  ds=(fall (~(get by side) syd) *desk-state)
  %+  ~(put by side)
    syd
  %=  ds
    work
      %+  ~(put by work.ds)
        pan
      (~(reqs pro *(promise mime)) paths)
  ==
::
++  install-files
  |=  {syd/desk pan/pname files/(list {path mime})}
  ^-  (quip move +>)
  :-  :~  (write-files syd files)
          [ost.hid %poke /resume/[syd] [our.hid %package] %package-action [%resume syd]]
      ==
  =+  ds=(~(got by side) syd)
  :: add sha to files - for installed-package map
  =/  installed-files
  %-  malt
  %+  turn  files
  |=  {pax/path mim/mime}
  [pax [pax (shax q.q.mim)]]
  :: add package name - for files map
  =/  files-to-package
  %-  malt
  %+  turn  files
  |=  {pax/path mim/mime}
  [pax pan]
  :: update state
  =.  side
  %+  ~(put by side)  syd
  %=  ds
    packages  (~(put by packages.ds) pan [pan installed-files])
    files  files-to-package
    queue  +.queue.ds
  ==
  +>.$
::
++  write-files
  |=  {syd/desk files/(list {path mime})}
  ^-  move
  =/  wr
  :*  syd
      %&
      %+  turn  files
      |=  {pax/path mim/mime}
      [pax [%ins [%mime !>(mim)]]]
  ==
  [ost.hid %info /writing our.hid wr]
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
:: if the last part of the path has an extension turn it into a mark
:: e.g.:  /foo/bar/baz.js -> /foo/bar/baz/js
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
  =+  queue-package=[%& pack]
  :: check that it's not already in the queue
  =+  ds=(~(got by side) syd)
  ?^  (find [queue-package]~ queue.ds)
    ~&  [%already-queued name.pack]
    [~ +>.$]
  :: add to queue
  =.  side
  %+  ~(put by side)  syd
  ds(queue [queue-package queue.ds])
  :: check prerequisites
  (install-package-dependencies syd pack)
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
  =+  pan=(snag 3 way)
  =+  pax=(slag 4 way)
  (file-fetched syd pan pax [/application/octet-stream (need r.res)])
::
++  file-fetched
  |=  {syd/desk pan/pname pax/path mim/mime}
  ^-  (quip move +>)
  =+  ds=(~(got by side) syd)
  =/  prom
  %+  ~(res pro (~(got by work.ds) pan))
    pax
  mim
  =.  side
  %+  ~(put by side)
    syd
  %=  ds
    work
      ?~  pending.prom
        (~(del by work.ds) pan)
      (~(put by work.ds) pan prom)
  ==
  ?~  pending.prom
    :: all files received - install them
    (install-files syd pan (~(tap by done.prom)))
  :: still waiting for other requests
  [~ +>.$]
::
++  sigh-tang
  |=  {way/wire tan/tang}
  ^-  (quip move +>)
  %-  (slog >%talk-sigh-tang< tan)
  [~ +>.$]
--

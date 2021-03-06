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
  $%  {$info wire ship toro:clay}
      {$poke wire {ship $package} $package-action action:package}
      {$hiss wire $~ mark {$purl purl:eyre}}
      {$warp wire sock riff:clay}
      {$merg wire ship desk ship desk case germ:clay}
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
  $:  queue/(list queue-package)               :: package install queue
      work/(map pname (promise mime))          :: per-package pending work
      deps/(jar pname {pan/pname has/@uv})     :: dependencies
  ==
--
::
|_  {hid/bowl:gall state}
::++  prep  _`.
::
++  poke-noun
  |=  a/*
  ^-  (quip move _+>)
  %-  poke-package-action
  ~|  [%strange-action a]
  ;;(action:package a)
::
++  poke-package-action
  |=  a/action:package
  ^-  (quip move _+>)
  ?>  (team:title our.hid src.hid)      :: don't allow strangers
  ?-  a
    {$install *}  (install-package-item +.a)
    {$installed *}  (get-installed-versions +.a)
    {$resume *}  (install-next-package +.a)
    {$help *}  (help +.a)
  ==
++  help
  |=  a/@tas
  ^-  (quip move _+>)
  =+  h=(~(get by action-help:package) a)
  ~&  ?~  h  action-help:package  [a u.h]
  [~ +>.$]
::
++  is-package-installed
  |=  {syd/desk pack/package:package}
  ^-  @f
  =+  pd=(package-desk syd name.pack)
  ?.  (desk-exists pd)
    |
  (label-exists pd (hash-to-label hash.pack))
::
++  get-installed-versions
  |=  {syd/desk pan/pname}
  ^-  (quip move _+>)
  =+  pd=(package-desk syd pan)
  ~&  lab:.^(dome:clay cv+/=[pd]/[(scot %da now.hid)])
  [~ +>.$]
::
++  install-package-item
  |=  {syd/desk pack/package-item:package}
  ^-  (quip move _+>)
  (install-package-items syd [%| pack]~)
::
++  install-package-items
  |=  {syd/desk packs/(list queue-package)}
  ^-  (quip move _+>)
  =+  ds=(fall (~(get by side) syd) *desk-state)
  =.  side
  %+  ~(put by side)  syd
  ds(queue (weld packs queue.ds))
  (install-next-package syd)
::
++  get-next-package
  |=  syd/desk
  ^-  (unit queue-package)
  %+  biff  (~(get by side) syd)
  |=  ds/desk-state
  ?~  queue.ds
    ~
  `-.queue.ds
::
++  install-next-package
  |=  syd/desk
  ^-  (quip move _+>)
  =+  qp=(get-next-package syd)
  ?~  qp
    [~ +>.$]
  =+  qp=u.qp
  ?-  qp
  {$& *}
    :: a package that was waiting for its dependencies
    :: since it's at the top of the queue we can merge its deps now
    (merge-deps syd name.+.qp &)
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
  ^-  (map desk desk-state)
  =+  ds=(~(got by side) syd)
  %+  ~(put by side)
    syd
  ds(queue +.queue.ds)
::
++  install-package-dependencies
  |=  {syd/desk pack/package:package}
  ^-  (quip move _+>)
  =+  ds=(~(got by side) syd)
  :: check that the package is not already pending
  ?:  (~(has by work.ds) name.pack)
    ~&  [%package-already-pending name.pack]
    [~ +>.$]
  :: check that the package is not already installed
  ?:  (is-package-installed syd pack)
    ~&  [%package-already-installed name.pack]
    :: remove from queue and resume
    =.  side  (pop-package-queue syd)
    =.  side  (record-dependency syd name.pack hash.pack)
    (install-next-package syd)
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
++  record-dependency
  |=  {syd/desk pan/pname has/@uv}
  ^-  (map desk desk-state)
  =+  ds=(~(got by side) syd)
  :: find next %& package in the queue
  =+  queue=queue.ds
  =/  dep
  ^-  (unit pname)
  |-
    ?~  queue
      ~
    ?.  ?=({$& *} -.queue)
      $(queue +.queue)
    (some name.->.queue)
  ?~  dep
    side
  %+  ~(put by side)  syd
  ds(deps (~(add ja deps.ds) u.dep [pan has]))
::
:: install a package that has its dependencies installed already
++  install-package
  |=  {syd/desk pack/package:package}
  ^-  (quip move _+>)
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
  ^-  (map desk desk-state)
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
  ^-  (quip move _+>)
  =+  ds=(~(got by side) syd)
  =+  qp=-.queue.ds
  ?>  ?=({$& *} qp)
  =+  hash=(scot %uv hash.+.qp)
  =+  pd=(package-desk syd pan)
  :-  :~  (subscribe-for-next-commit /install/file/[syd]/[pan]/[hash] pd)
          (write-files pd files)
      ==
  =.  side
  %+  ~(put by side)  syd
  %=  ds
    queue  +.queue.ds
  ==
  +>.$
::
++  subscribe-for-next-commit
  |=  {way/wire syd/desk}
  ^-  move
  =+  dom=.^(dome:clay cv+(base syd))
  =+  let=+(let.dom)
  =+  rav=[%sing %y ud+let /]
  [ost.hid %warp way [our.hid our.hid] [syd (some rav)]]
::
++  subscribe-to-label
  |=  {way/wire syd/desk label/@tas}
  ^-  move
  =+  rav=[%sing %y tas+label /]
  [ost.hid %warp way [our.hid our.hid] [syd (some rav)]]
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
++  writ-install-file
  |=  {way/wire rot/riot:clay}
  ^-  (quip move _+>)
  ?~  rot
    [~ +>.$]
  =+  syd=(snag 0 way)
  =+  pan=`pname`(snag 1 way)
  =+  has=`@uv`(slav %uv (snag 2 way))
  =+  was=.^(@uv cz+(base (package-desk syd pan)))
  ?.  =(has was)
    ~&  [%invalid-hash package=pan expected=has was=was]
    [~ +>.$]
  =.  side  (record-dependency syd pan has)
  ~&  [%installed name=`pname`pan hash=was]
  :: create a label so the version can be address by content hash
  =+  label=(hash-to-label has)
  :_  +>.$
  :~
    (create-label syd pan label)
    (subscribe-to-label /label/[syd]/[pan] (package-desk syd pan) label)
  ==
::
++  writ-label
  |=  {way/wire rot/riot:clay}
  ^-  (quip move _+>)
  ?~  rot
    [~ +>.$]
  =+  syd=(snag 0 way)
  (install-next-package syd)
::
:: labels can't start with anumber and can't contain dots so start with a
:: letter and replace dots with dashes
++  hash-to-label
  |=  {has/@uv}
  ^-  @tas
  =+  lab=(cat 3 'h' (scot %uv has))
  |-
    ?:  =(lab '')
      ''
    =+  first=(end 3 1 lab)
    %-  cat
    :-  3
    :_  $(lab (rsh 3 1 lab))
    ?:  =(first '.')
      '-'
    first
::
++  create-label
  |=  {syd/desk pan/pname label/@tas}
  ^-  move
  =+  pd=(package-desk syd pan)
  :: check that label doesn't exist yet
  ?:  (label-exists pd label)
    ~|  [%label-already-exists label=label]
    !!
  [ost.hid %info /label/[syd]/[pan]/[label] our.hid pd %| label]
::
++  label-exists
  |=  {syd/desk label/@tas}
  ^-  @f
  =+  dom=.^(dome:clay cv+/=[syd]/[(scot %da now.hid)])
  ?~  (~(get by lab.dom) label)
    |
  &
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
  |=  {url/purl:eyre pax/path}
  ^-  purl:eyre
  (scan "{(en-purl:html url)}{(spud pax)}" auri:de-purl:html)
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
  |=  {way/wire mar/mark url/purl:eyre}
  ^-  move
  ~&  [%fetching url=(en-purl:html url)]
  [ost.hid %hiss way ~ mar [%purl url]]
::
++  base
  |=  syd/desk
  ^-  path
  /[(scot %p our.hid)]/[syd]/[(scot %da now.hid)]
::
++  relpath-to-abs
  |=  {syd/desk pax/path}
  ^-  path
  (weld (base syd) pax)
::
++  desk-exists
  |=  syd/desk
  ^-  @f
  =+  ark=.^(arch cy+(base syd))
  !=(~ dir.ark)
::
++  package-desk
  |=  {syd/desk pan/pname}
  ^-  desk
  (rap 3 syd '-' pan ~)
::
++  merge-deps
  |=  {syd/desk pan/pname first/?}
  ^-  (quip move _+>)
  =+  ds=(~(got by side) syd)
  =+  deps=(~(get ja deps.ds) pan)
  ?~  deps
    ?.  first
      =+  qp=(need (get-next-package syd))
      ?>  ?=({$& *} qp)
      (install-package syd +.qp)
    :: no dependencies - reset to %base if needed
    :_  +>.$
    [ost.hid %merg /merge/[syd]/[pan] our.hid (package-desk syd pan) our.hid %base da+now.hid %that]~
  :: remove dep
  =.  side
  %+  ~(put by side)  syd
  ds(deps (~(put by deps.ds) pan +.deps))
  :_  +>.$
  :_  ~
  :*
    ost.hid
    %merg
    /merge/[syd]/[pan]
    our.hid
    (package-desk syd pan)
    our.hid
    (package-desk syd -<.deps)
    tas+(hash-to-label ->.deps)
    ?:(first %that %meet)
  ==
::
++  mere-merge
  |=  {wir/wire are/(each (set path) (pair term tang))}
  ^-  (quip move _+>)
  ?.  ?=({$.y *} are)
    ~&  [%merge-conflicts +.are]
    [~ +>.$]
  =+  syd=-.wir
  =+  pan=+<.wir
  (merge-deps syd pan |)
::
++  sigh-package-package
  |=  {way/wire pack/package:package}
  ^-  (quip move _+>)
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
  |=  {way/wire res/httr:eyre}
  ^-  (quip move _+>)
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
  ^-  (quip move _+>)
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
    (install-files syd pan ~(tap by done.prom))
  :: still waiting for other requests
  [~ +>.$]
::
++  sigh-tang
  |=  {way/wire tan/tang}
  ^-  (quip move _+>)
  %-  (slog >%talk-sigh-tang< tan)
  [~ +>.$]
--

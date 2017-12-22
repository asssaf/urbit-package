::
::::  /hoon/package/sur
  ::
|%
++  pname  @tas
++  package
  $:  name/pname
      hash/@uvI
      items/(list item)
  ==
++  item
  $%  {$package package-item}
      {$fileset fileset-item}
  ==
++  package-item  purl:eyre
++  fileset-item  {base/purl:eyre rels/(list path)}
++  action
  $%  {$install d/desk p/package-item:package}
      {$installed d/desk p/pname}
      {$resume d/desk}
      {$help @tas}
  ==
++  action-help
  %-  my
  :~  [%install arg=["desk-prefix purl"] desc="Fetch and install a pacakge in a prefix"]
      [%installed arg=["desk-prefix package-name"] desc="List installed versions of a package in a prefix"]
      [%resume arg=["desk-prefix"] desc="Resume installation in a prefix"]
      [%help arg=["action"] desc="Show help for action"]
  ==
--

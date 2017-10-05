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
++  package-item  purl
++  fileset-item  {base/purl rels/(list path)}
++  action
  $%  {$install d/desk p/package-item:package}
      {$resume d/desk}
      {$help @tas}
  ==
++  action-help
  %-  my
  :~  [%install arg=["desk purl"] desc="Fetch and install a pacakge in  a desk"]
      [%resume arg=["desk"] desc="Resume installation in a desk"]
      [%help arg=["action"] desc="Show help for action"]
  ==
--

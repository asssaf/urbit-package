::
::::  /hoon/package/sur
  ::
|%
++  pname  @tas
++  package
  $:  name/pname
      items/(list item)
  ==
++  item
  $%  {$package package-item}
      {$fileset fileset-item}
  ==
++  package-item  purl
++  fileset-item  {base/purl rels/(list path)}
++  action
  $%  {$installed d/desk}
      {$install d/desk p/package-item:package}
      {$uninstall d/desk p/pname}
      {$verify d/desk p/pname}
      {$contents d/desk p/pname}
      {$belongs d/desk pax/path}
      {$resume d/desk}
      {$help @tas}
  ==
++  action-help
  %-  my
  :~  [%installed arg=["desk"] desc="Show list of installed packages in a desk"]
      [%install arg=["desk purl"] desc="Fetch and install a pacakge in  a desk"]
      [%uninstall arg=["desk name"] desc="Uninstall package in a desk"]
      [%verify arg=["desk name"] desc="Verify files of package in a desk"]
      [%contents arg=["desk name"] desc="Show files of package in a desk"]
      [%belongs arg=["desk path"] desc="Show package owning path in a desk"]
      [%resume arg=["desk"] desc="Resume installation in a desk"]
      [%help arg=["action"] desc="Show help for action"]
  ==
--

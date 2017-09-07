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
  ==
--

::
::::  /hoon/package/sur
  ::
|%
++  package
  $:  name/@tas
      items/(list item)
  ==
++  item
  $%  {$package package-item}
      {$fileset fileset-item}
  ==
++  package-item  purl
++  fileset-item  {base/purl rels/(list path)}
--

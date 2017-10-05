::
::::  /hoon/install/package/gen
  ::
!:
:-  %say
|=  {^ args/{prefix/@tas url/tape $~} $~}
:-  %package-action
[%install prefix.args (scan url.args auri:epur)]

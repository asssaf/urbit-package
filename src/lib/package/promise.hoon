|%
++  promise
  |*  a/mold
  {pending/(set wire) done/(map wire a)}
++  pro
  |_  a/(promise)
  +-  req  :: register a promise
    |*  wir/wire
    %=  a
      pending  (~(put in pending.a) wir)
      done  (~(del by done.a) wir)
    ==
  +-  reqs  :: register multiple promises
    |*  wirs/(list wire)
    %=  a
      pending  (~(gas in pending.a) wirs)
      done  *_done.a
    ==
  ::
  +-  res  :: accept a result
    |*  {wir/wire r/*}
    %=  a
      pending  (~(del in pending.a) wir)
      done  (~(put by done.a) wir r)
    ==
  --
--

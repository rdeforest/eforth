#!/usr/bin/perl -i.prev -pn

if (/(version *0\.(\d+))/) {
  $v = $2 + 1;
  s/$2/$v/e;
}


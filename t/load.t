#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

for (qw(
  Collection
  Test::Collection
)) {
  use_ok($_);
}

done_testing;

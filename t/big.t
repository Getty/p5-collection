#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Collection;

use Collection;

my @big_base = (
  ( map { 'a'.$_, 1 } 'a'..'c' ),
  ( map { 'b'.$_, 2 } 'a'..'c' ),
  ( map { 'c'.$_, 3 } 'a'..'c' ),
);

collection_test([ @big_base ],"big",
  sub { $_[0]->keys(2) }, [qw( ba bb bc )], undef,
  sub { $_[0]->keys(2,1) }, [qw( aa ab ac ba bb bc )], undef,
);

done_testing;

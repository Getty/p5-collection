#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Collection;

use Collection;

my @simple_base = ( a => 1, b => 2, c => 3 );

collection_test([ @simple_base ],"simple",
  sub { $_[0]->get("a") }, [ 1 ], undef,
  sub { $_[0]->get("c") }, [ 3 ], undef,
  sub { $_[0]->add( d => 4 ) }, [ 4 ], [ @simple_base, d => 4 ],
  sub { $_[0]->add( a => 4 ) }, [ 4 ], [ b => 2, c => 3, a => 4 ],
  sub { $_[0]->add( a => 4, b => 5 ) }, [ 4, 5 ], [ c => 3, a => 4, b => 5 ],
  sub { $_[0]->put( d => 4 ) }, [ 4 ], [ d => 4, @simple_base ],
  sub { $_[0]->set( d => 4 ) }, [ 4 ], [ @simple_base, d => 4 ],
  sub { $_[0]->set( b => 4 ) }, [ 4 ], [ a => 1, b => 4, c => 3 ],
  sub { $_[0]->set( a => 4 ) }, [ 4 ], [ a => 4, b => 2, c => 3 ],
  sub { $_[0]->set( a => 4, c => 5 ) }, [ 4, 5 ], [ a => 4, b => 2, c => 5 ],
  sub { $_[0]->set( b => 4, d => 5 ) }, [ 4, 5 ], [ a => 1, b => 4, c => 3, d => 5 ],
  sub { $_[0]->put( b => 4 ) }, [ 4 ], [ b => 4, a => 1, c => 3 ],
  sub { $_[0]->put( b => 4, d => 5 ) }, [ 4, 5 ], [ b => 4, d => 5, a => 1, c => 3 ],
  sub { $_[0]->delete("b") }, [ 2 ], [ a => 1, c => 3 ],
  sub { $_[0]->delete("b","c") }, [ 2, 3 ], [ a => 1 ],
  sub { $_[0]->after( b => d => 4 ) }, [ 4 ], [ a => 1, b => 2, d => 4, c => 3 ],
  sub { $_[0]->after( b => d => 4, e => 5 ) }, [ 4, 5 ], [ a => 1, b => 2, d => 4, e => 5, c => 3 ],
  sub { $_[0]->before( b => d => 4 ) }, [ 4 ], [ a => 1, d => 4, b => 2, c => 3 ],
  sub { $_[0]->before( b => d => 4, e => 5 ) }, [ 4 ], [ a => 1, d => 4, e => 5, b => 2, c => 3 ],
  sub { $_[0]->pos("b") }, [ 1 ], undef, # alias idx
  sub { $_[0]->pos("b","c") }, [ 1, 2 ], undef, # alias idx
  sub { $_[0]->shift }, [ 1 ], [ b => 2, c => 3 ],
  sub { $_[0]->pop }, [ 3 ], [ a => 1, b => 2 ],
  sub { shift @{$_[0]} }, [ 1 ], [ b => 2, c => 3 ],
  sub { pop @{$_[0]} }, [ 3 ], [ a => 1, b => 2 ],
  sub { $_[0]->fetch }, [ a => 1 ], [ b => 2, c => 3 ],
  sub { $_[0]->take }, [ c => 3 ], [ a => 1, b => 2 ],
  sub { $_[0]->fetch("b") }, [ b => 2 ], [ a => 1, c => 3 ],
  sub { $_[0]->take("b") }, [ b => 2 ], [ a => 1, c => 3 ],
  sub { @{$_[0]} }, [ 1, 2, 3 ], undef,
  sub { %{$_[0]} }, { a => 1, b => 2, c => 3 }, undef,
  sub { $_[0]->{d} = 4 }, [ 4 ], [ @simple_base, d => 4 ],
  sub { $_[0]->{b} = 4 }, [ 4 ], [ a => 1, b => 4, c => 4 ],
  sub { delete $_[0]->{b} }, [ 2 ], [ a => 1, c => 3 ],
  sub { exists $_[0]->{b} }, [ 1 ], undef,
  sub { exists $_[0]->{d} }, [ 0 ], undef,
  sub { $_[0]->exists("b") }, [ 1 ], undef,
  sub { $_[0]->exists("d") }, [ 0 ], undef,
  sub { $_[0]->exists("b","d") }, [ 1, 0 ], undef,
  sub { $_[0]->keys }, [qw( a b c )], undef,
  sub { $_[0]->keys(2,1) }, [qw( a b )], undef, # seek keys of given values
  sub { $_[0]->values }, [qw( 1 2 3 )], undef,
  sub { $_[0]->values("b","c") }, [qw( 2 3 )], undef,
  sub { $_[0]->list }, [ @simple_base ], undef,
  sub { $_[0]->splice(1) }, [ 2, 3 ], [ a => 1 ],
  sub { $_[0]->splice(1,1) }, [ 2 ], [ a => 1, c => 1 ],
  sub { $_[0]->splice(1) }, 3, [ a => 1 ],
  sub { $_[0]->splice(1,1) }, 2, [ a => 1, c => 1 ],
  sub { splice @{$_[0]},2 }, [ 1, 2 ], [ c => 3 ],
  sub { splice @{$_[0]},2,1 }, [ 2, 3 ], [ a => 1 ],
  sub { splice @{$_[0]},2 }, 2, [ c => 3 ],
  sub { splice @{$_[0]},2,1 }, 3, [ a => 1 ],
  sub { $_[0]->cut(2,1) }, [ b => 2, c => 3 ], [ a => 1 ],
  sub { $_[0]->section(2,1) }, [ b => 2, c => 3 ], undef,
  sub { $_[0]->length }, [ 3 ], undef,
);

# TODO checking results of functions who give back Collections themself
my @simple_tests_newcollresult = (
  sub { $_[0]->clone }, [ @simple_base ], [ @simple_base ],
  sub { $_[0]->collice(2,1) }, [ b => 2, c => 3 ], [ a => 1 ], # haha funny naming
);

collection_test_errors([ @simple_base ],"simple",
  sub { $_[0]->splice(2,0,"newval") }, qr/auto_key/,
  sub { $_[0]->collice(2,0,"newval") }, qr/auto_key/,
  sub { $_[0]->push("newval") }, qr/auto_key/,
  sub { $_[0]->unshift("newval") }, qr/auto_key/,
);

done_testing;

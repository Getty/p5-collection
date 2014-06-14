package Collection;
# ABSTRACT: Ordered Hash with modern API

use strict;
use warnings;
use Carp qw( croak );

sub new {
  my ( $class, @args ) = @_;
  my $self = ( scalar @args == 1 && ref $args[0] eq 'HASH' )
    ? $args[0] : { collection => [ @args ] };
  return bless $self, $class;
}

sub get {}

sub add {}
sub set {}
sub put {}
sub after {}
sub before {}

sub delete {}
sub pos {}
sub exists {}
sub length {}

sub shift {}
sub pop {}
sub fetch {}
sub take {}

sub push { croak "requires auto_key" unless defined $_[0]->{auto_key} }
sub unshift { croak "requires auto_key" unless defined $_[0]->{auto_key} }

sub keys {}
sub values {}

sub splice {}
sub collice {}
sub cut {}

sub clone {}

sub section {}

sub list { @{$_[0]->collection} }
sub collection { $_[0]->{collection} }

1;

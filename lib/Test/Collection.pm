package Test::Collection;
# ABSTRACT: test suite for testing collection

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw(
  collection_test
  collection_test_errors
);

use B::Deparse ();
my $deparse = B::Deparse->new;

sub codetext {
  my $code = shift;
  my $code_text = $deparse->coderef2text($code);
  my @all_code_lines = split("\n",$code_text);
  my @code_lines = map { $_ =~ s/^\s+//g; $_ =~ s/\s+$//g; $_; } @all_code_lines;
  @code_lines = grep { !/^use/ } @code_lines;
  my $code_name = join(" ",@code_lines);
}

sub collection_test {
  my ( $coll_list, $coll_name, @tests ) = @_;
  while (@tests) {
    my ( $code, $return, $result_coll_list ) = splice(@tests,0,3);
    my $test_name = $coll_name." with ".codetext($code);
    my $collection = Collection->new(@{$coll_list});
    if (ref $return eq 'ARRAY') {
      my @ret; eval { @ret = $code->($collection) };
      main::is_deeply([ @ret ],[ @{$return} ],"return ".$test_name);
    } elsif (ref $return eq 'HASH') {
      my %ret; eval { %ret = $code->($collection) };
      main::is_deeply({ %ret },{ %{$return} },"return ".$test_name);
    } else {
      my $ret; eval { $ret = scalar($code->($collection)) };
      if (defined $ret) {
        main::is_deeply($ret,$return,"return ".$test_name);
      }
    }
    if (defined $result_coll_list) {
      main::is_deeply($collection->collection,$result_coll_list,"result collection ".$test_name);
    }
  }
}

sub collection_test_errors {
  my ( $coll_list, $coll_name, @tests ) = @_;
  while (@tests) {
    my ( $code, $error ) = splice(@tests,0,2);
    my $test_name = "errors on ".$coll_name." with ".codetext($code);
    my $collection = Collection->new(@{$coll_list});
    eval {
      $code->($collection);
    };
    main::like($@,$error,$test_name);
  }
}

1;

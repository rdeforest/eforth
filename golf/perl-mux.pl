#!/usr/bin/perl

use strict;
use warnings;

my @streams = ();

foreach (@ARGV) {
  open(my $fh, '<', $_);

  @streams = insertSorted({ STREAM => $fh, NEXT => $fh->getline }, @streams);
}

# this could be O(log(n)) instead of O(n)
sub insertSorted {
  my ($new, @streams) = @_;

  for (my $i = 0; $i <= $#streams; $i++) {
    if ($new->{NEXT} lt $streams[$i]->{NEXT}) {
      splice @streams, $i, 0, $new;
      return @streams;
    }
  }

  push @streams, $new;
  return @streams;
}

while (@streams) {
  my $min;
  ($min, @streams) = @streams;

  print $min->{NEXT};

  unless ($min->{STREAM}->eof()) {
    $min->{NEXT} = $min->{STREAM}->getline;
    @streams = insertSorted($min, @streams);
  }
}

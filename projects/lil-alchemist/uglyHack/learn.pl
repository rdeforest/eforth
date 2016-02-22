#!/usr/bin/perl

use strict;
use warnings;

my @fields = ();
my $line;
my $id;
my $card = shift @ARGV;
my $fh;
my $f;
my %seen;

while ($line = <>) {
  chomp $line;

  if ($line eq ")tr") {
    next unless $id =~ /Table$/;

    `mkdir -p "cards/$card/$id"`;
    open($fh, '>', $f = "cards/$card/$id/" . shift @fields)
      or die "Error opening $f: $!";
    print $fh join("\n", @fields);
    @fields = ();
    next;
  }

  my $flag = substr $line, 0, 1;
  my $data = substr $line, 1;

  if ($flag eq "-") {
    $data =~ s/\\[nt]//g;
    $data =~ s/^\s*//;
    $data =~ s/\s*$//;

    if ($data) {
      push @fields, $data;
    }

    next;
  }

  if ($flag eq "A") {
    my ($attr, undef, $value) = split / /, $data, 3;

    if ($attr eq "id") {
      $id = (split /-/, $value)[-1];
    }
  }
}

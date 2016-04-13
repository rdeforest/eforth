#!/usr/bin/perl

use strict;
use warnings;

my $cards = {};

my @queue = @ARGV or allCards();

for my $card (@queue) {
  readCard($card);
}

my @unknown = grep { ! -e "cards/$_" } keys %$cards;

if (@unknown) {
  print "Unfetched:\n  ", join("  \n", @unknown), "\n";
}

sub readCard {
  my ($card) = @_;
  my @comboList = readDir("cards/$card/combosTable");
  my @recipeList = readDir("cards/$card/recipesTable");
  my $combos = {};
  my $recipes = {};

  for my $other (@comboList) {
    my ($product, undef) = readFile("cards/$card/combosTable/$other");
    $combos->{$other} = $product;
  }

  for my $left (@recipeList) {
    my ($right) = readFile("cards/$card/recipesTable/$left");
    $recipes->{$left} = $right;
  }

  makeCard($card, $combos, $recipes);
}

sub makeCard {
  my ($name, $combos, $recipes) = @_;
  my $card = $cards->{$name} = $cards->{$name} || {combos => {}, recipes => {}};

  while (my ($other, $product) = each %$combos) {
    if (defined $card->{combos}{$other}) {
      warn "Replacing contents of $name/combos/$other";
    }

    $card->{combos}{$other} = $product;
  }

  while (my ($left, $right) = each %$recipes) {
    if (defined $card->{recipes}{$left}) {
      warn "Replacing contents of $name/recipes/$left";
    }

    $card->{recipes}{$left} = $right;
  }
}

sub allCards { readDir('cards') }

sub readDir {
  my ($d) = @_;

  opendir(D, $d)
    or die "error opening $d: $!";

  grep {/^[^.]/} readdir(D);
}

sub readFile {
  my ($path) = @_;

  open(F, '<', $path)
    or die "Cannot read $path: $!";

  map { chomp } (<F>);
}

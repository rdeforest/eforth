#!/usr/bin/perl

use strict;
use warnings;

use Linux::Inotify2;
use IO::Select;

my $inotify = new Linux::Inotify2
  or die "unable to create inotify object: $!";

my $select = new IO::Select;

my $interesting = qr{/test};
my %fileNames = ();
my %fileHandles = ();
my %lines = ();

sub watchFile {
  my $file = shift;

  if (open(my $fh, '<', $file)) {
    $select->add($fh);
    $fileHandles{$fh} = $file;
    $fileNames{$file} = $fh;
  } else {
    warn "Error opening '$file': $!\n";
  }
}

sub countLines {
  my $fh = shift;

  my $name = $fileHandles{$fh};
  $lines{$name} += scalar(my @lines = $fh->getlines());
  print "$name: $lines{$name}\n";
  if ($lines{$name} > 10) {
    die "wat";
  }
}

sub maybeAddFileWatcher {
  my $e = shift;
  my $name = $e->fullname;

  if ($name =~ $interesting && !$fileNames{$name}) {
    watchFile($name);
  }
}

sub watchDir {
  my $dir = shift;

  $inotify->watch($dir, IN_ALL_EVENTS, \&maybeAddFileWatcher);
}

watchDir(".");

while (1) {
  $inotify->poll();

  my @ready = $select->can_read(3);

  countLines($_) foreach @ready;
}


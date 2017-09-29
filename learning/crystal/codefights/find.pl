sub find {
  my ($predicate, @array) = @_;

  for my $el (@array) {
    if ($predicate->($el)) {
      return $el
    }
  }
}

sub findIterator {
  my ($predicate, @array) = @_;
  my $idx = 0

  sub {
    for my $el (@array
  }
}

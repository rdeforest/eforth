$order = sub { $a->{NEXT} cmp $b->{NEXT} };

@streams =
    sort $order
    map { open(my $fh, '<', $_);
        { STREAM => $fh, NEXT => $fh->getline } }
    @ARGV;

while (@streams) {
  ($min, @streams) = @streams;

  print $min->{NEXT};
  next if $min->{STREAM}->eof();

  $min->{NEXT} = $min->{STREAM}->getline;
  @streams = sort $order @streams, $min;
}

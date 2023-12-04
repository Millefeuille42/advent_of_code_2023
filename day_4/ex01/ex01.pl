#!/usr/bin/env perl

my $extract_re = qr/Card +(?<card_number>\d+): +(?<winning_numbers>(?:\d+ *?)+) \| +(?<player_numbers>(?:\d+ *)+)/;
sub get_card_score {
    my ($line) = @_;
    if ($line =~ $extract_re) {
        my $count = grep { my $num = $_; grep { $_ eq $num } split(' ', $+{player_numbers}) } split(' ', $+{winning_numbers});
        return $count 
    }
    return 0;
}

my $file = 'data.txt';
open my $fh, '<', $file or die;

my @cards = ();
while (my $line = <$fh>) {
    chomp $line;
    push @cards, [1, get_card_score($line)];
}
close $fh;

my $total_count = 0;
for ($index = 0; $index < scalar @cards; $index++) {
    my ($card_count, $card_score) = @{$cards[$index]};
    $total_count += $card_count;

    my $begin = $index + 1;
    my $end = $card_score + $index;
    foreach my $add_index ($begin..$end) {
	$cards[$add_index][0] += $card_count;
    }
}
    
print "$total_count\n";

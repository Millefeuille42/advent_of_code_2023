#!/usr/bin/env perl

open(my $fh, '<', 'data.txt') or die;
my $sum = 0;

while (my $line = <$fh>) {
    if ($line =~ /Card +(?<card_number>\d+): +(?<winning_numbers>(?:\d+ *?)+) \| +(?<player_numbers>(?:\d+ *)+)/) {
        my $count = grep { my $num = $_; grep { $_ eq $num } split(' ', $+{player_numbers}) } split(' ', $+{winning_numbers});
        $sum += $count ? 2 ** ($count - 1) : 0;
    }
}

print "$sum\n";
close($fh);
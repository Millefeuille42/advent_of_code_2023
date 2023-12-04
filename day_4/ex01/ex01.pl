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

my %cards_hash;
sub init {
    my ($index, $score) = @_;
    # 0 is the number of cards, 1 is the precomputed result
    $cards_hash{$index} //= [];
    $cards_hash{$index}[0] //= 0;
    $cards_hash{$index}[1] //= $score;
    $cards_hash{$index}[0]++;
}

sub increment {
    my ($index) = @_;
    $cards_hash{$index}[0]++;
}

my $file = 'data.txt';
open my $fh, '<', $file or die;

my @cards = ();
my $index = 0;
while (my $line = <$fh>) {
    chomp $line;
    init($index, get_card_score($line));
    push @cards, $line;
    $index++;
}
close $fh;

my $total_count = 0;
for ($index = 0; $index < scalar @cards; $index++) {
    my ($card_count, $card_score) = @{$cards_hash{$index}};
    foreach my $count (1..$card_count) {
        $total_count++;
        my $begin = $index + 1;
        my $end = $card_score + $index;
        foreach my $add_index ($begin..$end) {
            increment($add_index);
        }
    }
}
    
print "$total_count\n";
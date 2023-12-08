import re
from collections import Counter
from typing import Dict, List, Tuple
from enum import Enum

line_regexp = re.compile(r"(?P<hand>[AKQJT2-9]+)\s+(?P<bid>\d+)")


def most_common_char_count(input_string):
    char_count = Counter(input_string)
    most_common = char_count.most_common(1)
    _, count = most_common[0]
    return count


def count_pairs(s):
    char_count = Counter(s)
    return sum(count // 2 for count in char_count.values())


def get_distinct(hand: str) -> int:
    return len(set(hand))


class HandType(Enum):
    FIVE_OF_A_KIND = 6
    FOUR_OF_A_KIND = 5
    FULL_HOUSE = 4
    THREE_OF_A_KIND = 3
    TWO_PAIR = 2
    ONE_PAIR = 1
    HIGH_CARD = 0

    @classmethod
    def from_hand(cls, hand: str):
        distinct = get_distinct(hand)
        pairs = count_pairs(hand)
        most = most_common_char_count(hand)
        mappings = {
            1: HandType.FIVE_OF_A_KIND,
            4: HandType.ONE_PAIR,
            5: HandType.HIGH_CARD
        }
        if distinct in mappings:
            return mappings[distinct]
        if distinct == 2:
            return HandType.FOUR_OF_A_KIND if most == 4 else HandType.FULL_HOUSE
        if distinct == 3:
            return HandType.THREE_OF_A_KIND if most == 3 else HandType.TWO_PAIR


class Hand:
    def __init__(self, hand: str, bid: int):
        self.hand = hand
        self.bid = bid
        self.type = HandType.from_hand(hand)


def extract_hand_from_line(line: str) -> Hand:
    matches = line_regexp.match(line).groupdict()
    return Hand(matches['hand'], int(matches['bid']))


def main():
    file = open('data.txt', 'r')
    lines = file.readlines()
    hand_list_dict: Dict[HandType, List[Hand]] = {}
    for line in lines:
        hand = extract_hand_from_line(line)
        if hand.type not in hand_list_dict:
            hand_list_dict[hand.type] = []
        hand_list_dict[hand.type].append(hand)


if __name__ == "__main__":
    main()

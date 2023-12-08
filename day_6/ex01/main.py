import re
from math import sqrt, pow, ceil


def polynomial(a, b, c):
    com = sqrt(pow(b, 2) - 4*a*c)
    return ceil((-b + com) / (2*a) + 0.0001), ceil((-b - com) / (2*a))


if __name__ == "__main__":
    file = open('ex00/data.txt', 'r')
    lines = file.readlines()
    number_regexp = re.compile(r"\d+")

    record_distance = number_regexp.findall(lines.pop().strip().replace(" ", ""))[0]
    race_time = number_regexp.findall(lines.pop().strip().replace(" ", ""))[0]
    lim1, lim2 = polynomial(-1, int(race_time), -int(record_distance))
    print(lim2 - lim1)

import re
from math import sqrt, pow, ceil


def polynomial(a, b, c):
    com = sqrt(pow(b, 2) - 4*a*c)
    mn = 0.0001
    return ceil((-b + com) / (2*a) + mn), ceil((-b - com) / (2*a))


if __name__ == "__main__":
    file = open('ex00/data.txt', 'r')
    lines = file.readlines()
    number_regexp = re.compile(r"\d+")
    record_distances = number_regexp.findall( lines.pop().strip())
    race_times = number_regexp.findall(lines.pop().strip())
    total = 1
    for record_distance, race_time in zip(record_distances, race_times):
        lim1, lim2 = polynomial(-1, int(race_time), -int(record_distance))
        res = ceil(lim2 - lim1) - 1
        total *= lim2 - lim1
    print(total)

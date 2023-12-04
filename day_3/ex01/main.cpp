#include <iostream>
#include <fstream>
#include <string>
#include <regex>

void get_numbers(const std::string *line, const size_t begin, const size_t end, const std::regex &re, std::vector<int> &matches) {
    if (!line) return;
    const std::string &line_ref = *line;
    std::smatch match;
    const std::string sub = line_ref.substr(begin, end - begin + 1);

    std::sregex_iterator iterator(sub.begin(), sub.end(), re);
    for (const std::sregex_iterator end_iterator; iterator != end_iterator && matches.size() < 2; ++iterator) {
        const std::smatch& match_num = *iterator;
        long num_begin = match_num.position() + begin;
        for (; num_begin >= 0 && std::isdigit(line_ref[num_begin]); num_begin--) {}
        if (num_begin < 0 || !std::isdigit(line_ref[num_begin])) num_begin++;

        long num_end = num_begin;
        for (; num_end < line_ref.length() && std::isdigit(line_ref[num_end]); num_end++) {}
        if (num_end >= line_ref.length() || !std::isdigit(line_ref[num_end])) num_end--;

        std::string full_number = line_ref.substr(num_begin, num_end - num_begin + 1);
        int full_num = std::stoi(full_number);
        matches.push_back(full_num);
    }
}

int main() {
    std::ifstream file("data.txt");
    if (!file.is_open()) {
        perror("could not open file");
        return 1;
    }

    std::vector<std::string> lines(0);
    for (std::string line; getline(file, line);) lines.push_back(line);
    file.close();

    std::vector<long> ratios(0);
    std::regex number_regex("[0-9]+");
    std::regex gear_regex("\\*");

    // This is dirty, but it eases the reading of the file
    //  as far as I am concerned, it doesn't have to be clean ¯\_(ツ)_/¯
    for (size_t line_number = 0; line_number < lines.size(); ++line_number) {
        std::string const &line = lines[line_number];
        std::string const *top_line = line_number > 0 ? &lines[line_number - 1] : nullptr;
        std::string const *bottom_line = line_number < lines.size() - 1 ? &lines[line_number + 1] : nullptr;

        std::sregex_iterator iterator(line.begin(), line.end(), gear_regex);
        for (std::sregex_iterator end_iterator; iterator != end_iterator; ++iterator) {
            const std::smatch& match = *iterator;
            size_t begin = match.position() > 0 ? match.position() - 1 : match.position();
            size_t end = match.position() + match.length() < line.length() ? match.position() + match.length() : line.length() - 1;
            std::vector<int> matches(0);

            get_numbers(top_line, begin, end, number_regex, matches);
            get_numbers(&line, begin, end, number_regex, matches);
            get_numbers(bottom_line, begin, end, number_regex, matches);

            if (matches.size() >= 2) ratios.push_back(matches[0] * matches[1]);
        }
    }

    long sum = 0;
    for (long ratio : ratios) {
        sum += ratio;
    }
    std::cout << sum << std::endl;

    return 0;
}
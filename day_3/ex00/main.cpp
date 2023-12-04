#include <iostream>
#include <fstream>
#include <string>
#include <regex>

bool has_symbol(const std::string *line, const size_t begin, const size_t end, const std::regex &re) {
    if (!line) return false;
    std::smatch match;
    const std::string sub = line->substr(begin, end - begin + 1);
    return regex_search(sub, match, re);
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

    std::vector<int> parts(0);
    std::regex part_regex("[0-9]+");
    std::regex symbol_regex("[^0-9.]");

    // This is dirty, but it eases the reading of the file
    //  as far as I am concerned, it doesn't have to be clean ¯\_(ツ)_/¯
    for (size_t line_number = 0; line_number < lines.size(); ++line_number) {
        std::string const &line = lines[line_number];
        std::string const *top_line = line_number > 0 ? &lines[line_number - 1] : nullptr;
        std::string const *bottom_line = line_number < lines.size() - 1 ? &lines[line_number + 1] : nullptr;

        std::sregex_iterator iterator(line.begin(), line.end(), part_regex);
        for (std::sregex_iterator end_iterator; iterator != end_iterator; ++iterator) {
            const std::smatch& match = *iterator;
            size_t begin = match.position() > 0 ? match.position() - 1 : match.position();
            size_t end = match.position() + match.length() < line.length() ? match.position() + match.length() : line.length() - 1;

            if (
                has_symbol(top_line, begin, end, symbol_regex) ||
                has_symbol(&line, begin, end, symbol_regex) ||
                has_symbol(bottom_line, begin, end, symbol_regex)
            ) parts.push_back(stoi(match.str()));
        }
    }

    long sum = 0;
    for (int part : parts) {
        sum += part;
    }
    std::cout << sum << std::endl;

    return 0;
}
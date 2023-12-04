#include <iostream>
#include <fstream>
#include <string>
#include <regex>

using namespace std;

int main(void) {
    std::ifstream file("data.txt");
    if (!file.is_open()) {
        perror("could not open file");
        return 1;
    }

    vector<std::string> lines(0);
    for (std::string line; getline(file, line);) lines.push_back(line);
    file.close();

    vector<int> parts(0);
    regex re("[0-9]+");

    // This is dirty, but it eases the reading of the file
    //  as far as I am concerned, it doesn't have to be clean ¯\_(ツ)_/¯
    for (size_t line_number = 0; line_number < lines.size(); ++line_number) {
        std::string const &line = lines[line_number];
        std::string const *top_line = line_number > 0 ? &lines[line_number - 1] : nullptr;
        std::string const *bottom_line = line_number < lines.size() - 1 ? &lines[line_number + 1] : nullptr;


        std::sregex_iterator iterator(line.begin(), line.end(), re);
        for (std::sregex_iterator end_iterator; iterator != end_iterator; ++iterator) {
            std::smatch match = *iterator;
            bool got_symbol = false;
            size_t pos = match.position();
            for (size_t i = 0; i <= match.length(); i++) {
                // Look backwards and left diagonals (skipped when i == 0)
                if (i == 0 && pos > 0) got_symbol = line[pos - 1] != '.' && !std::isdigit(line[pos - 1]);
                if (got_symbol) {parts.push_back(stoi(match.str())); break;}
                if (!got_symbol && i == 0 && top_line && pos > 0) got_symbol = (*top_line)[pos - 1] != '.' && !std::isdigit((*top_line)[pos - 1]);
                if (got_symbol) {parts.push_back(stoi(match.str())); break;}
                if (!got_symbol && i == 0 && bottom_line && pos > 0) got_symbol = (*bottom_line)[pos - 1] != '.' && !std::isdigit((*bottom_line)[pos - 1]);
                if (got_symbol) {parts.push_back(stoi(match.str())); break;}

                // Look above and below (everytime + 1 in front)
                if (!got_symbol && pos < line.length()) got_symbol = line[pos] != '.' && !std::isdigit(line[pos]);
                if (got_symbol) {parts.push_back(stoi(match.str())); break;}
                if (!got_symbol && pos < line.length() && top_line) got_symbol = (*top_line)[pos] != '.' && !std::isdigit((*top_line)[pos]);
                if (got_symbol) {parts.push_back(stoi(match.str())); break;}
                if (!got_symbol && pos < line.length() && bottom_line) got_symbol = (*bottom_line)[pos] != '.' && !std::isdigit((*bottom_line)[pos]);
                if (got_symbol) {parts.push_back(stoi(match.str())); break;}
                pos++;
            }
        }
    }

    long sum = 0;
    for (vector<int>::const_iterator parts_iterator = parts.begin(); parts_iterator != parts.end(); ++parts_iterator) {
        sum += *parts_iterator;
    }
    std::cout << sum << endl;

    return 0;
}
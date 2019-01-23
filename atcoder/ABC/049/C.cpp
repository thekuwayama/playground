#include <iostream>
#include <cstdlib>
#include <regex>
#include <cstdio>
#include <string>

using namespace std;

int main(void) {
  regex re("^(dream|dreamer|erase|eraser)+$");
  string s;
  getline(cin, s);

  if (regex_match(s, re)) {
    cout << "YES" << endl;
  } else {
    cout << "NO" << endl;
  }
  return EXIT_SUCCESS;
}

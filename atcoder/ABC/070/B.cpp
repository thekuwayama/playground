#include <iostream>
#include <cstdlib>

using namespace std;

int main(void) {
  int a, b, c, d;
  cin >> a >> b >> c >> d;

  if (b < c) {
    // a b c d
    cout << 0 << endl;
  } else if (a <= c and c <= b and b <= d) {
    // a c b d
    cout << b - c << endl;
  } else if (a <= c and d <= b) {
    // a c d b
    cout << d - c << endl;
  } else if (c <= a and b <= d) {
    // c a b d
    cout << b - a << endl;
  } else if (c <= a and a <= d and d <= b) {
    // c a d b
    cout << d - a << endl;
  } else {
    // c d a b
    cout << 0 << endl;
  }
  return EXIT_SUCCESS;
}

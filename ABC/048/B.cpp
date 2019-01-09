#include <iostream>
#include <cstdlib>

using namespace std;

int main(void) {
  long a, b, x;
  cin >> a >> b >> x;

  long res = 0;
  for (long i = a; i <= b; i += x - i % x) {
    if (i % x == 0) {
      res = 1 + (b - i) / x;
      break;
    }
  }
  cout << res << endl;
  return EXIT_SUCCESS;
}

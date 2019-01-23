#include <iostream>
#include <cstdlib>

using namespace std;

int main(void) {
  int n;
  cin >> n;

  unsigned long long res = 1;
  for (int i = 1; i <= n; i++) {
    res = (res * i) % 1000000007;
  }
  cout << res << endl;
  return EXIT_SUCCESS;
}

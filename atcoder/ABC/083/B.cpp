#include <iostream>
#include <cstdlib>
#include <cstdio>

using namespace std;

int main(void) {
  int n, a, b;
  cin >> n >> a >> b;

  int res = 0;
  for (int i = 0; i <= n; i++) {
    char s[6] = { 0 };
    sprintf(s, "%04d", i);
    int sum = s[0] + s[1] + s[2] + s[3] - '0' * 4;
    if (sum >= a and sum <= b) {
      res += i;
    }
  }
  cout << res << endl;
  return EXIT_SUCCESS;
}

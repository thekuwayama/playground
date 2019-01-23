#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

int main(void) {
  int n;
  char s[300000];
  cin >> n >> s;

  int wcount[300000] = { 0 };
  for (int i = 1; i < n; i++) {
    if (i == 0) {
      continue;
    } else if (i == 1 and s[i - 1] == 'W') {
      wcount[i] = 1;
    } else if (i > 1 and s[i - 1] == 'W') {
      wcount[i] = 1 + wcount[i - 1];
    } else {
      wcount[i] = wcount[i - 1];
    }
  }

  int ecount[300000] = { 0 };
  for (int i = n - 1; i >= 0; i--) {
    if (i == n - 1) {
      continue;
    } else if (i == n - 2 and s[i + 1] == 'E') {
      ecount[i] = 1;
    } else if (i < n - 2 and s[i + 1] == 'E') {
      ecount[i] = 1 + ecount[i + 1];
    } else {
      ecount[i] = ecount[i + 1];
    }
  }

  int res[300000] = { 0 };
  for (int i = 0; i < n; i++) {
    res[i] = wcount[i] + ecount[i];
  }
  sort(res, res + n);
  cout << res[0] << endl;
  return EXIT_SUCCESS;
}

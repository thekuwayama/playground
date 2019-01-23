#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

int main(void) {
  int n, c, k;
  cin >> n >> c >> k;
  int t[100000];
  for (int i = 0; i < n; i++) {
    cin >> t[i];
  }

  sort(t, t + n);
  int departure = -1;
  int got = 0;
  int res = 1;
  for (int i = 0; i < n; i++) {
    if (departure < 0) {
      departure = t[i] + k;
      got = 1;
    } else if (departure < t[i]) {
      departure = t[i] + k;
      got = 1;
      res++;
    } else if (got == c) {
      departure = t[i] + k;
      got = 1;
      res++;
    } else {
      got++;
    }
  }
  cout << res << endl;
  return EXIT_SUCCESS;
}

#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <functional>
#include <climits>

using namespace std;

int main(void) {
  int n, k;
  cin >> n >> k;
  int h[100000];
  for (int i = 0; i < n; i++) {
    cin >> h[i];
  }

  sort(h, h + n, greater<int>());
  int res = INT_MAX;
  for (int i = 0; i + k - 1 < n; i++) {
    res = min(res, h[i] - h[i + k - 1]);
  }
  cout << res << endl;
  return EXIT_SUCCESS;
}

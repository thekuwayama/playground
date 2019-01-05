#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

int main(void) {
  int n;
  int d[101];
  cin >> n;
  for (int i = 0; i < n; i++) {
    cin >> d[i];
  }

  sort(d, d + n);
  int *u = unique(d, d + n);
  int res = distance(d, u);
  cout << res << endl;
  return EXIT_SUCCESS;
}

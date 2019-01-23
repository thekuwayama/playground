#include <iostream>
#include <cstdlib>
#include <cmath>
#include <algorithm>

using namespace std;

int main(void) {
  int n;
  cin >> n;
  while (getchar() != '\n');

  int a[200];
  for (int i = 0; i < n; i++) {
    cin >> a[i];
  }

  int res[200];
  for (int i = 0; i < n; i++) {
    int count = 0;
    while (a[i] % 2 == 0) {
      a[i] /= 2;
      count++;
    }
    res[i] = count;
  }
  cout << *min_element(res, res + n) << endl;
  return EXIT_SUCCESS;
}

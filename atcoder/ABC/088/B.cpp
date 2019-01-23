#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

int main(void) {
  int n;
  int a[100];
  cin >> n;
  for (int i = 0; i < n; i++) {
    cin >> a[i];
  }

  sort(a, a + n, greater<int>());
  int alice, bob;
  alice = bob = 0;
  for (int i = 0; i < n; i++) {
    if (i % 2 == 0) {
      alice += a[i];
    } else {
      bob += a[i];
    }
  }
  cout << alice - bob << endl;
  return EXIT_SUCCESS;
}

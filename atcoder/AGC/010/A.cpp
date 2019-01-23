#include <iostream>
#include <cstdlib>

using namespace std;

int main(void) {
  int n;
  cin >> n;
  int neven, nodd;
  neven = nodd = 0;
  for (int i = 0; i < n; i++) {
    int ai;
    cin >> ai;
    if (ai % 2 == 0) {
      neven++;
    } else {
      nodd++;
    }
  }

  if ((nodd == 1 and neven == 0) or
      (nodd % 2 == 0) {
    cout << "YES" << endl;
  } else {
    cout << "NO" << endl;
  }
  return EXIT_SUCCESS;
}

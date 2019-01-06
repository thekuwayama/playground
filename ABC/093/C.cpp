#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

int main(void) {
  int x[3];
  for (int i = 0; i < 3; i++) {
    cin >> x[i];
  }

  sort(x, x + 3);
  int da, db;
  da = x[2] - x[0];
  db = x[2] - x[1];
  int res;
  if (da % 2 == 0 and db % 2 == 0) {
    res = da / 2 + db / 2;
  } else if (da % 2 == 1 and db % 2 == 1) {
    res = 1 + (da - 1) / 2 + (db - 1) / 2;
  } else if (da % 2 == 0 and db % 2 == 1) {
    res = 1 + da / 2 + (db + 1) / 2;
  } else if (da % 2 == 1 and db % 2 == 0) {
    res = 1 + (da + 1) / 2 + db / 2;
  }
  cout << res << endl;
  return EXIT_SUCCESS;
}

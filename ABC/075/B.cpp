#include <iostream>
#include <cstdlib>

using namespace std;

int main(void) {
  int x[52][52] = { {0} };
  int h, w;
  cin >> h >> w;
  for (int i = 1; i <= h; i++) {
    for (int j = 1; j <= w; j++) {
      char xij;
      cin >> xij;
      if (xij == '#') {
        x[i][j] = 1;
      }
    }
  }

  for (int i = 1; i <= h; i++) {
    for (int j = 1; j <= w; j++) {
      if (x[i][j] == 1) {
        cout << '#';
        continue;
      }
      int bc =
        + x[i - 1][j - 1] + x[i][j - 1] + x[i + 1][j - 1]
        + x[i - 1][j]                   + x[i + 1][j]
        + x[i - 1][j + 1] + x[i][j + 1] + x[i + 1][j + 1];
      cout << bc;
    }
    cout << endl;
  }
  return EXIT_SUCCESS;
}

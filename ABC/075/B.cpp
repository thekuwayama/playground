#include <iostream>
#include <cstdlib>

using namespace std;

int main(void) {
  char x[52][52] = { {0} };
  int h, w;
  cin >> h >> w;
  for (int i = 1; i <= h; i++) {
    for (int j = 1; j <= w; j++) {
      cin >> x[i][j];
    }
  }

  for (int i = 1; i <= h; i++) {
    for (int j = 1; j <= w; j++) {
      if (x[i][j] == '#') {
        cout << '#';
        continue;
      }
      int count = 0;
      if (x[i][j - 1] == '#') {
        count++;
      }
      if (x[i + 1][j - 1] == '#') {
        count++;
      }
      if (x[i + 1][j] == '#') {
        count++;
      }
      if (x[i + 1][j + 1] == '#') {
        count++;
      }
      if (x[i][j + 1] == '#') {
        count++;
      }
      if (x[i - 1][j + 1] == '#') {
        count++;
      }
      if (x[i - 1][j] == '#') {
        count++;
      }
      if (x[i - 1][j - 1] == '#') {
        count++;
      }
      cout << count;
    }
    cout << endl;
  }
  return EXIT_SUCCESS;
}

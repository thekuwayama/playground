#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cmath>

using namespace std;

const int BUFLEN = 1024;

int main(void) {
  int n;
  cin >> n;
  while (getchar() != '\n');

  int t[100001], x[100001], y[100001];
  t[0] = x[0] = y[0] = 0;
  for (int i = 1; i <= n; i++) {
    char buf[BUFLEN];
    fgets(buf, BUFLEN, stdin);
    sscanf(buf, "%d %d %d", t + i, x + i, y + i);
  }

  for (int i = 0; i < n; i++) {
    int dx = abs(x[i + 1] - x[i]);
    int dy = abs(y[i + 1] - y[i]);
    int dt = abs(t[i + 1] - t[i]);
    bool ok = dx + dy <= dt and (dx + dy) % 2 == dt % 2;
    if (not ok) {
      cout << "No" << endl;
      return EXIT_SUCCESS;
    }
  }
  cout << "Yes" << endl;
  return EXIT_SUCCESS;
}

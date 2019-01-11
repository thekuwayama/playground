#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

int main(void) {
  int n;
  cin >> n;
  int a[3][101] = { { 0 } };
  for (int i = 1; i <= 2; i++) {
    for (int j = 1; j <= n; j++) {
      cin >> a[i][j];
    }
  }

  int memo[3][101] = { { 0 } };
  for (int i = 1; i <= 2; i++) {
    for (int j = 1; j <= n; j++) {
      memo[i][j] = a[i][j] + max(memo[i - 1][j], memo[i][j - 1]);
    }
  }
  cout << memo[2][n] << endl;
  return EXIT_SUCCESS;
}

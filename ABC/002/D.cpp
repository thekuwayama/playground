#include <iostream>
#include <cstdlib>
#include <bitset>

using namespace std;

int main(void) {
  int n, m;
  cin >> n >> m;
  
  const int NMAX = 12;
  int table[NMAX][NMAX] = { { 0 } };
  for (int i = 0; i < m; i++) {
    int x, y;
    cin >> x >> y;
    table[x - 1][y - 1] = table[y - 1][x - 1] = 1;
  }

  if (m == 0) {
    cout << 1 << endl;
    return EXIT_SUCCESS;
  }
  int ans = 0;
  for (int i = (1 << n) - 1; i > 0; i--) {
    bitset<12> pattern(i);
    // cout << pattern << endl;

    bool ok = true;
    for (int s = 0; s < n; s++) {
      for (int t = s + 1; t < n; t++) {
        // cout << s + 1 << " x " << t + 1 << " = " << table[s][t] << endl;
        if (pattern[s] & pattern[t] and not table[s][t]) {
          ok = false;
          goto LABEL;
        }
      }
    }
  LABEL:
    int c = pattern.count();
    if (ok and c > ans){
      ans = c;
    }
  }
  cout << ans << endl;
  return EXIT_SUCCESS;
}

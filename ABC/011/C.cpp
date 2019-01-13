#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

bool is_ng(int to, int ng[]);

int main(void) {
  int n, ng[3];
  cin >> n;
  for (int i = 0; i < 3; i++) {
    cin >> ng[i];
  }

  int memo[301] = { 0 };
  for (int from = 0; from < n; from++) {
    for (int j = 1; j <= 3; j++) {
      int to = from + j;
      if ((from == 0 or memo[from] > 0) and to < 301 and not is_ng(to, ng)) {
        memo[to] = memo[to] == 0 ? memo[from] + 1 : min(memo[to], memo[from] + 1);
      }
    }
  }

  /*
  for (int i = 0; i <= n; i++) {
    cout << memo[i] << ' ';
  }
  cout << endl;
  */
  if (memo[n] > 0 and memo[n] <= 100) {
    cout << "YES" << endl;
  } else {
    cout << "NO" << endl;
  }
  return EXIT_SUCCESS;
}

bool is_ng(int to, int ng[]) {
  return ng[0] == to or ng[1] == to or ng[2] == to;
}

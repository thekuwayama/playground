#include <iostream>
#include <cstdlib>
#include <algorithm>

using namespace std;

int main(void) {
  int n, m, rmax;
  cin >> n >> m >> rmax;
  int r[8];
  for (int i = 0; i < rmax; i++) {
    cin >> r[i];
    r[i]--;
  }
  int dist[200][200];
  for (int i = 0; i < 200; i++) {
    for (int j = 0; j < 200; j++) {
      if (i == j) {
        dist[i][j] = 0;
      } else {
        dist[i][j] = 1e8;
      }
    }
  }
  for (int i = 0; i < m; i++) {
    int a, b, c;
    cin >> a >> b >> c;
    dist[a - 1][b - 1] = c;
    dist[b - 1][a - 1] = c;
  }

  for (int k = 0; k < n; k++) {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j]);
      }
    }
  }
  /*
  for (int i = 0; i < m; i++) {
    for (int j = 0; j < m; j++) {
      cout << dist[i][j] << " ";
    }
    cout << endl;
  }
  cout << "---------------" << endl;
  */

  sort(r, r + rmax);
  int ans = 1e8;
  do {
    int progress = 0;
    for (int i = 0; i + 1 < rmax; i++) {
      int from = r[i];
      int to = r[i + 1];
      int d = dist[from][to];
      progress += d;
    }
    ans = min(ans, progress);
  } while (next_permutation(r, r + rmax));
  cout << ans << endl;
  return EXIT_SUCCESS;
}

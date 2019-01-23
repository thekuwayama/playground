#include <iostream>
#include <cstdlib>

using namespace std;

long n;
int res;
void dfs(long x, bool seven, bool five, bool three) {
  if (x > n) {
    return;
  }
  if (seven and five and three) {
    res++;
  }

  dfs(10 * x + 7, true, five, three);
  dfs(10 * x + 5, seven, true, three);
  dfs(10 * x + 3, seven, five, true);
}

int main(void) {
  cin >> n;

  res = 0;
  dfs(0, false, false, false);
  cout << res << endl;
  return EXIT_SUCCESS;
}

#include <iostream>
#include <cstdlib>

using namespace std;

int main(void) {
  int n, y;
  cin >> n >> y;

  for (int i = y / 10000; i >= 0; i--) {
    for (int j = (y - i * 10000) / 5000; j >= 0; j--) {
      int l = (y - i * 10000 - j * 5000) / 1000;
      if (i + j + l == n) {
        cout << i << ' ' << j << ' ' << l << endl;
        return EXIT_SUCCESS;        
      }
    }
  }
  cout << "-1 -1 -1" << endl;
  return EXIT_SUCCESS;
}

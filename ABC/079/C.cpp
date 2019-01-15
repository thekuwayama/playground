#include <iostream>
#include <cstdlib>
#include <cstdio>

int op(int n, int eo);

using namespace std;

int main(void) {
  char a, b, c, d;
  cin >> a >> b >> c >> d;

  int na, nb, nc, nd;
  na = a - '0';
  nb = b - '0';
  nc = c - '0';
  nd = d - '0';
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 2; j++) {
      for (int k = 0; k < 2; k++) {
        int sum = na + op(nb, i) + op(nc, j) + op(nd, k);
        if (sum == 7) {
          printf("%d%+d%+d%+d=7\n", na, op(nb, i), op(nc, j), op(nd, k));
          return EXIT_SUCCESS;
        } else {
          ;
        }
      }      
    }
  }
  return EXIT_SUCCESS;
}

int op(int n, int eo) {
  if (eo % 2 == 1) {
    return -n;
  } else {
    return n;
  }
}

#include <iostream>
#include <cmath>
#include <cstdio>

using namespace std;

int main(void) {
  int xa, ya, xb, yb, xc, yc;
  cin >> xa >> ya >> xb >> yb >> xc >> yc;

  double s = abs((xa - xc) * (yb - yc) - (xb - xc) * (ya - yc)) * 0.5;
  s = int(s * 10) / 10.0;
  printf("%.1lf\n", s);
  return EXIT_SUCCESS;
}

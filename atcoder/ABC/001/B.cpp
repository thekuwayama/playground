#include <iostream>
#include <cstdio>

using namespace std;

int main(void) {
  int m;
  cin >> m;

  double km = m / 1000.0;
  if (km < 0.1) {
    cout << "00" << endl;
  } else if (km <= 5) {
    printf("%02d\n", int(km * 10));
   }else if (km <= 30) {
    cout << int(km) + 50 << endl;
  } else if (km <= 70) {
    cout << int((km - 30) / 5 + 80) << endl;
  } else {
    cout << "89" << endl;
  }
  return 0;
}

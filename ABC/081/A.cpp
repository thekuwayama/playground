#include <iostream>
#include <cstdlib>
#include <bitset>

using namespace std;

int main(void) {
  bitset<3> masu;
  cin >> masu;

  cout << masu.count() << endl;
  return EXIT_SUCCESS;
}

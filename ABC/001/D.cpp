#include <iostream>
#include <string>
#include <cstdio>

using namespace std;

const int BUFSIZE = 1024;

int main(void) {
  int n;
  cin >> n;
  while (getchar() != '\n');

  const int RESSIZE = 12 * 24 + 1;
  int res[RESSIZE] = { 0 };
  for (int i = 0; i < n; i++) {
    int sh, sm, eh, em;
    char buf[BUFSIZE];
    fgets(buf, sizeof(buf), stdin);
    sscanf(buf, "%2d%2d-%2d%2d", &sh, &sm, &eh, &em);

    int s = sh * 12 + sm / 5;
    int e = eh * 12 + em / 5 + (em % 5 ? 1 : 0);
    for (int j = s; j < e; j++) {
      res[j] = 1;
    }
  }

  /*
  for (int i = 0; i < RESSIZE; i++) {
    cout << res[i];
  }
  cout << endl;
  */

  bool raining = false;
  for (int i = 0; i < RESSIZE; i++) {
    if (not raining and res[i] == 0) {
      continue;
    } else if (not raining) {
      int sh = i / 12;
      int sm = i % 12 * 5;
      printf("%02d%02d-", sh, sm);
      raining = true;
    } else if (raining and res[i] == 0) {
      int eh = i / 12;
      int em = i % 12 * 5;
      printf("%02d%02d\n", eh, em);
      raining = false;
    } else {
      continue;
    }
  }
  return EXIT_SUCCESS;
}

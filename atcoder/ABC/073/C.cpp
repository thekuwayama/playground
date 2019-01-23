#include <iostream>
#include <cstdlib>
#include <set>

using namespace std;

int main(void) {
  int n;
  cin >> n;
  set<int> st;
  for (int i = 0; i < n; i++) {
    int ai;
    cin >> ai;
    auto itr = st.find(ai);
    if (itr == st.end()) {
      st.insert(ai);
    } else {
      st.erase(itr);
    } 
  }
  
  cout << st.size() << endl;
  return EXIT_SUCCESS;
}

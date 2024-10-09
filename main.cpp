#include<iostream>
#include "vector.h"

using namespace std;

int main () {
  Vector<int> v1;
  Vector<int> v2;

  cout << "Vector empty: " << (v1.empty() ? "true" : "false") << std::endl;
  v1.reserve(234);
  v1.begin() == v1.begin();
  cout << v1.size() << "\n";
  return 0;
}

#include<iostream>
#include "vector.h"

using namespace std;

int main () {
  Vector<int> v1(1);
  Vector<int> v2(1);

  cout << "Vector empty: " << (v1.empty() ? "true" : "false") << std::endl;
  v1.reserve(234);
 
  cout << v1.size() << (v1.begin() == v1.begin()) << "\n";
  return 0;
}

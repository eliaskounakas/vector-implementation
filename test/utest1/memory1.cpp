#include "vector.h"

using namespace std;

// KOMPATIBILITAET MIT WOCHE #3
#ifndef NO_TEMPLATES
#define Vector Vector<double>
#endif

int main(){

  Vector y;
  {
    Vector x(10);
    for(double i{0};i<1;i+=0.1)
      x.push_back(i);
    cout << x << endl;
    x.pop_back();
    cout << x << endl;
    x.shrink_to_fit();
    cout << x << endl;
    y = x;
    Vector tmp{y};
  }
  cout << y << endl;
  Vector x{1,2,3};
  for(size_t i{4};i<10000;++i)
    x.push_back(i);
  cout << "Done" << endl;
}

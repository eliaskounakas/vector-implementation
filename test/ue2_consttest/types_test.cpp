#include<iostream>
#include"vector.h"
using namespace std;

// KOMPATIBILITAET MIT WOCHE #3
#ifndef NO_TEMPLATES
#define Vector Vector<int>
#endif

int main() {

  Vector::value_type val;
  Vector::size_type size;
  Vector::difference_type diff;
  Vector::reference ref = val;
  Vector::const_reference cref = val;
  Vector::pointer ptr = &val;
  Vector::const_pointer cptr = &val;
  Vector::iterator *it;
  Vector::const_iterator *cit;

  return 0;
}

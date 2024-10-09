#include<iostream>

// Programm, um den hoechsten C-Standard bekommen zu koennen
// Damit wird bestimmt, ob mit -std=c++17 oder -std=c++11 kompiliert wird.
int main(void){
	std::cout << __cplusplus;
}

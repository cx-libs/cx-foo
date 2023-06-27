
#include <cstdint>
#include <map>
#include <memory>
#include <iostream>
#include <cxfoo/cxfoo.h>

using namespace std;


int main() {
  auto foo = cxfoo::Foo::New("foo");
  foo.HelloWorld();
  cout << foo.name() << endl;
}
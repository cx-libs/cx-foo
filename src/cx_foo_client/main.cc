#include <cstdint>
#include <map>
#include <memory>
#include <iostream>
#include <cx_foo/cx_foo.h>

using namespace std;
using namespace cx;

int main() {
  auto foo = foo::Foo::New("foo");
  foo.HelloWorld();
  cout << foo.name() << endl;
}

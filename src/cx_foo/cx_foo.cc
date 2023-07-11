#include <cx_foo/cx_foo.h>

#include <iostream>

namespace cx::foo {

class FooImpl {
 public:
  std::string name = "foo";

  FooImpl() {}
  FooImpl(const std::string& name_) : name(name_) {}
  ~FooImpl() {}
  void HelloWorld() {
    std::cout << "Hello World" << std::endl;
  }
};

// Window
Foo Foo::New(const std::string& name) { return Foo{std::make_shared<FooImpl>(name)}; }
void Foo::HelloWorld() { return impl->HelloWorld(); }
std::string Foo::name() { return impl->name; }

}  // namespace cx::foo

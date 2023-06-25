#include "cx_foo.h"

namespace cx_foo {

class FooImpl {
 public:
  FooImpl() {}
  ~FooImpl() {}
};

// Window
Foo Foo::New() {
  return Foo{std::make_shared<FooImpl>()};
}

}  // namespace cx_foo

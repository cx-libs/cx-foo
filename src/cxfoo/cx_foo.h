#pragma once

#include <memory>
#include "cx_foo_export.h"

namespace cx_foo {

template <typename T>
class SharedBase {
 public:
  std::shared_ptr<T> impl{};
  constexpr SharedBase() noexcept = default;
  constexpr SharedBase(std::shared_ptr<T> _impl) noexcept : impl{_impl} {};
  ~SharedBase() noexcept = default;
  constexpr SharedBase(SharedBase&&) noexcept = default;
  constexpr SharedBase& operator=(SharedBase&&) noexcept = default;
  constexpr SharedBase(const SharedBase&) noexcept = default;
  constexpr SharedBase& operator=(const SharedBase&) noexcept = default;
  constexpr bool operator==(std::nullptr_t) noexcept { return !impl; };
  constexpr bool operator==(const SharedBase& r) noexcept { return impl == r.impl; };
};

class FooImpl;
class Foo : public SharedBase<FooImpl> {
 public:
  CX_FOO_EXPORT static Foo New();
};

}  // namespace cx_foo

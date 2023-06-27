#pragma once

#include <string>
#include <memory>

#include "cxfoo_export.h"

namespace cxfoo {

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
  CXFOO_EXPORT static Foo New(const std::string& name);
  CXFOO_EXPORT void HelloWorld();
  CXFOO_EXPORT std::string name();
};

}  // namespace cxfoo

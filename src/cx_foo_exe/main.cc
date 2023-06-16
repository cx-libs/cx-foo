//#include <cx_foo/cx_foo.h>

#include <cstdint>
#include <map>
#include <memory>
#include <iostream>

#include <cx_queue/QueueContainer.h>

int main() {
    std::map<uint16_t, std::shared_ptr<int>> m;
    m.insert({ 0,nullptr });
    m.insert({ 4,nullptr });
    std::cout << "dadad" << std::endl;
}
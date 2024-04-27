#include "SmolinVariant.hpp"

#include <iostream>
#include <chrono>

using namespace std::chrono;

int main()
{
    SmolinVariant sv;

    auto start = high_resolution_clock::now();
    auto [p, q] = sv.factorN(918092443);
    auto end = high_resolution_clock::now();

    duration<double, std::milli> duration_ms = end - start;

    std::cout << "[Time] - " << duration_ms.count() << " ms" << std::endl;
    std::cout << "[Result] - " << p << " * " << q << std::endl;

    return 0;
}

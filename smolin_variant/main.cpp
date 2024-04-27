#include "SmolinVariant.hpp"

#include <iostream>
#include <chrono>

using namespace std::chrono;

int main()
{
    SmolinVariant sv;
    int1024_t num("670571563");

    auto start = high_resolution_clock::now();
    auto [p, q] = sv.factorN(num);
    auto end = high_resolution_clock::now();

    duration<double, std::milli> duration_ms = end - start;

    std::cout << "[Time] - " << duration_ms.count() << " ms" << std::endl;
    std::cout << "[Result] - " << p << " * " << q << std::endl;

    return 0;
}

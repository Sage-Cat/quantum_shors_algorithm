#ifndef SMOLINVARIANT_HPP
#define SMOLINVARIANT_HPP

#include <boost/multiprecision/cpp_int.hpp>
#include <utility>
#include <tuple>

using namespace boost::multiprecision;
using std::pair;

class SmolinVariant
{
public:
    pair<int1024_t, int1024_t> factorN(int1024_t N);

private:
    static std::tuple<int1024_t, int1024_t, int1024_t> extended_gcd(int1024_t a, int1024_t b);

    int1024_t computeA(int1024_t N);
};

#endif // SMOLINVARIANT_HPP

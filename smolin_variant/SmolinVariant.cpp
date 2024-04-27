#include "SmolinVariant.hpp"

#include <iostream>

using namespace std;

using namespace boost::multiprecision;

pair<int1024_t, int1024_t> SmolinVariant::factorN(int1024_t N)
{
    cout << "[Factor N] N=" << N << endl;

    int1024_t a = computeA(N);
    cout << "[Factor N] A=" << a << endl;

    int1024_t g = gcd(a, N);
    if (g > 1 && g < N)
    {
        cout << "[Factor N] Found factor g=" << g << endl;
        return {g, N / g};
    }

    cout << "[Factor N] Factor was not found" << endl;

    return {1, N};
}

tuple<int1024_t, int1024_t, int1024_t> SmolinVariant::extended_gcd(int1024_t a, int1024_t b)
{
    int1024_t x0 = 1, xn = 0;
    int1024_t y0 = 0, yn = 1;
    int1024_t q, temp;

    while (b != 0)
    {
        q = a / b;
        temp = a % b;
        a = b;
        b = temp;

        temp = xn;
        xn = x0 - q * xn;
        x0 = temp;

        temp = yn;
        yn = y0 - q * yn;
        y0 = temp;
    }
    return {a, x0, y0};
}

int1024_t SmolinVariant::computeA(int1024_t N)
{
    int1024_t testA = rand() % N; 

    while (testA < N)
    {
        int1024_t g = gcd(testA, N);
        if (g > 1 && g < N)
        {
            return testA;
        }
        testA++; 
    }

    return 1;
}

namespace Quantum.ShorsAlgorithm {
    open Microsoft.Quantum.Intrinsic;

    // Greatest Common Divisor (GCD)
    operation GreatestCommonDivisor(a : Int, b : Int) : Int {
        mutable remainder = a % b;
        mutable currentA = a;
        mutable currentB = b;

        while (remainder != 0) {
            set currentA = currentB;
            set currentB = remainder;
            set remainder = currentA % currentB;
        }
        return currentB;
    }

    // Corrected Calculating base^exponent for integers
    operation PowI(base : Int, exponent : Int) : Int {
        mutable result = 1;
        for i in 1..exponent {
            set result = result * base;
        }
        return result;
    }

    // Operation to simulate the order-finding subroutine classically
    operation FindOrderClassically(a : Int, N : Int) : Int {
        mutable r = 1;
        mutable result = a;

        // Loop to find the order 'r'
        while (result != 1) {
            set result = (result * a) % N;
            set r = r + 1;
        }

        // Return the found order
        return r;
    }
}

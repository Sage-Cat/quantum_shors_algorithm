/// This Q# program implements Smolin's variation of Shor's algorithm.
namespace Sample {
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Math;

    // N1=1843=19*97
    // N2=16837=113*149
    // N4=20373811=5449*3739
    // N3=918092443=20929*43867
    @EntryPoint()
    operation Main() : (Int, Int) {
        let N = 1843; // = 19*97
        // let N = 16837; // = 113*149
        // let N = 20373811; // =5449*3739
        // let N = 918092443; // = 20929*43867

        let (p, q) = SmolinVarOfShorsAlgorithm(N);
        Message($"Found factorization {N} = {p} * {q}");

        return (p, q);
    }
    

    /// # Summary
    /// Uses Smolin's variation of  Shor's algorithm to factor an input number.
    ///
    /// # Input
    /// ## number
    /// A semiprime integer to be factored.
    ///
    /// # Output
    /// Pair of numbers p > 1 and q > 1 such that p⋅q = `number`
    operation SmolinVarOfShorsAlgorithm(number : Int) : (Int, Int) {
        // First check the most trivial case (the provided number is even).
        if number % 2 == 0 {
            Message("An even number has been given; 2 is a factor.");
            return (number / 2, 2);
        }

        mutable foundFactors = false;
        mutable factors = (1, 1);
        mutable attempt = 1;
        repeat {
            Message($"*** Factorizing {number}, attempt {attempt}.");

            let generator = DrawRandomInt(1, number - 1);

            if GreatestCommonDivisorI(generator, number) == 1 {
                Message($"Assume that period=2.");

                // Smolin variation
                let period = 2;

                set (foundFactors, factors) =
                    MaybeFactorsFromPeriod(number, generator, period);
            }
            else {
                let gcd = GreatestCommonDivisorI(number, generator);

                Message($"We have guessed a divisor {gcd}");

                set foundFactors = true;
                set factors = (gcd, number / gcd);
            }

            set attempt = attempt+1;
            if (attempt > 100000) {
                fail "Failed to find factors: too many attempts!";
            }
        }
        until foundFactors
        fixup {
            Message("We did not found factors this time.");
        }

        return factors;
    }

    /// # Summary
    /// Tries to find the factors of `modulus` given a `period` and `generator`.
    ///
    function MaybeFactorsFromPeriod(
        modulus : Int,
        generator : Int,
        period : Int)
    : (Bool, (Int, Int)) {
        // Compute `generator` ^ `period/2` mod `number`.
        let halfPower = ExpModI(generator, period / 2, modulus);

        // If we are unlucky, halfPower is just -1 mod N, which is a trivial
        // case and not useful for factoring.
        if halfPower != modulus - 1 {
            // When the halfPower is not -1 mod N, halfPower-1 or
            // halfPower+1 share non-trivial divisor with `number`. Find it.
            let factor = MaxI(
                GreatestCommonDivisorI(halfPower - 1, modulus),
                GreatestCommonDivisorI(halfPower + 1, modulus)
            );

            // Add a flag that we found the factors, and return only if computed
            // non-trivial factors (not like 1:n or n:1)
            if (factor != 1) and (factor != modulus) {
                Message($"Found factor={factor}");
                return (true, (factor, modulus / factor));
            }
        }

        Message($"Found trivial factors.");
        return (false, (1, 1));
    }
}
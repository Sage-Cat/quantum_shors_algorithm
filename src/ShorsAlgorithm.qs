/// This Q# program implements Smolin's variation of Shor's algorithm.
namespace Sample {
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Math;

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
    /// Uses Smolin's variation of  Shor's algorithm to factor an input N.
    ///
    /// # Input
    /// ## N
    /// A semiprime integer to be factored.
    ///
    /// # Output
    /// Pair of Ns p > 1 and q > 1 such that p⋅q = `N`
    operation SmolinVarOfShorsAlgorithm(N : Int) : (Int, Int) {
        mutable foundFactors = false;
        mutable factors = (1, 1);
        mutable attempt = 1;
        repeat {
            Message($"*** Factoring  {N}, attempt {attempt}.");

            let generator = FindA(N);

            if GreatestCommonDivisorI(generator, N) == 1 {
                Message($"Assume that period=2.");

                // Smolin variation
                let period = 2;

                set (foundFactors, factors) =
                    MaybeFactorsFromPeriod(N, generator, period);
            }
            else {
                let gcd = GreatestCommonDivisorI(N, generator);

                Message($"We have guessed a divisor {gcd}");

                set foundFactors = true;
                set factors = (gcd, N / gcd);
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

    operation FindA(N : Int) : (Int) {
        mutable candidateA = 1;
        mutable found = false;
        mutable testA = 2;

        Message($"Starting searching needed 'a' for N={N}");
        // Use a while loop to iterate until a suitable `a` is found or all candidates have been tested.
        while (not found) and (testA < N) {
            if ((testA * testA) % N == 1  ) {
                set candidateA = testA;
                set found = true;
            }
            set testA = testA + 1;
        }

        Message($"Found 'a'={candidateA}");

        // Return the found candidate or 1 if none are suitable
        return candidateA;
    }

    /// # Summary
    /// Tries to find the factors of `modulus` given a `period` and `generator`.
    ///
    function MaybeFactorsFromPeriod(
        modulus : Int,
        generator : Int,
        period : Int)
    : (Bool, (Int, Int)) {
        // Compute `generator` ^ `period/2` mod `N`.
        let halfPower = ExpModI(generator, period / 2, modulus);

        // If we are unlucky, halfPower is just -1 mod N, which is a trivial
        // case and not useful for factoring.
        if halfPower != modulus - 1 {
            // When the halfPower is not -1 mod N, halfPower-1 or
            // halfPower+1 share non-trivial divisor with `N`. Find it.
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
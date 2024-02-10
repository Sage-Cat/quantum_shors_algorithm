namespace Quantum.ShorAlgorithm {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Diagnostics;

    open QuantumRandomNumberGenerator;

    // Define an operation to simulate Shor's algorithm for N=15 with full-ranged logs
    operation SimulateShorsAlgorithmWithLogs(N : Int) : (Int, Int) {
        Message($"Starting Shor's Algorithm simulation");

        // Step 1: Classical preprocessing, ensure gcd(a, N) = 1
        mutable a = 0;
        mutable gcd = 0;
        
        // Use Repeat-Until loop to find 'a' where gcd(a, N) = 1
        repeat {
            set a = GenerateRandomNumberInRange(N); // Generate a new 'a'
            set gcd = GreatestCommonDivisor(a, N); // Recalculate gcd
            Message($"Calculated GCD of {a} and {N} is {gcd}.");
        } until (gcd == 1)
        fixup {
        }

        // Step 2: Simplified quantum phase estimation to find 'r', the period of a^x mod N
        // This step is highly simplified in this demonstration
        let r = 4; // For a=7 and N=15, the period r is known to be 4
        Message($"Assumed period r for a={a} and N={N} is {r}.");

        // Step 3: Classical post-processing to find factors
        let factor1 = GreatestCommonDivisor(PowI(a, r / 2) + 1, N);
        let factor2 = GreatestCommonDivisor(PowI(a, r / 2) - 1, N);
        Message($"Factors found: {factor1} and {factor2}.");

        // Log the result
        Message($"Simulation complete. Factors of {N} are {factor1} and {factor2}.");

        // Return the factors
        return (factor1, factor2);
    }

    // Main entry point
    @EntryPoint()
    operation Main() : Unit {
        let N = 256;
        let (factor1, factor2) = SimulateShorsAlgorithmWithLogs(N);

        Message($"Simulation completed. The factors found are {factor1} and {factor2}.");
    }
}

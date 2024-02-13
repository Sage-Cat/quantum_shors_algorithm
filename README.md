# Quantum Factoring with Shor's Algorithm

## Introduction  
This project demonstrates integer factoring using quantum computing, inspired by notable research. It showcases Shor's algorithm's efficiency compared to classical methods.

### Smolin's Shor Algorithm Variation

1. **Choose a Random Number**: Select an integer `a` that is less than `N` but greater than 1. In Smolin’s variation, we do not find `a` as a random value, but we calculate it according to the formula `a^2 = 1 mod N` using the Extended Euclidean Algorithm.
    
2. **Greatest Common Divisor (GCD)**: Calculate the GCD of `a` and `N` using the Euclidean algorithm. If the GCD is not 1, it is a non-trivial factor of `N`. 
    
3. **Quantum Fourier Transform (QFT)**: Prepare a quantum state and perform QFT on it. This step is crucial for finding the periodicity in the quantum state that relates to the factors of `N`. In Smolin’s variation, we will just assume that `r = 2` and skip this step.
    
4. **Modular Exponentiation**: Execute a quantum operation that maps the base state to a new state representing `a^x mod N`.
    
5. **Measurement**: Measure the quantum state to obtain an outcome that, with high probability, is related to the period of `a` modulo `N`.
    
6. **Post-Processing**: Use classical algorithms to extract factors of `N` from the measured value. If we have no factors, then repeat.

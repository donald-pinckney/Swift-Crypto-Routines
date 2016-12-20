# Swift Crypto Routines
Here you can find clear and readable implementations of various common Cryptography routines, in pure Swift. 

Note that this code **SHOULD NOT AT ALL** be used for production or security-critical applications. Rather, the purpose of Swift Crypto Routines is to have clear, readable, and beautiful code to best explain practical Cryptography.  Hence, most of this code is horribly slow compared to actual crypto libraries, and the time has not been taken to verify its security.  However, the routines should be *correct*.

Please peruse the collection of implemented routines, and their linked specifications below. Lastly, pull requests with fixes, improvements, or new routines are welcome! 

## Swift Crypto Routines - Currently Implemented Routines
## Block Ciphers
- [AES-128, AES-192, AES-256](https://github.com/donald-pinckney/Swift-Crypto-Routines/blob/master/Sources/AES/AES.swift): The most common block cipher in use today. [PDF Specification](http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf)

## Encryption Schemes
- [FF1](https://github.com/donald-pinckney/Swift-Crypto-Routines/blob/master/Sources/FF1/FF1.swift): A [format-preserving encryption scheme](https://en.wikipedia.org/wiki/Format-preserving_encryption). [PDF Specification](http://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-38G.pdf)

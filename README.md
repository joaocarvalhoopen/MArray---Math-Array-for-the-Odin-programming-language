# MArray - Math Array for the Odin programming language
A very simple version of a Math Array library for Odin, inspired by NumPy and others.

## Description
Creation of a simple version inspired on NumPy, Julia or Matlab math array processing kind of tools, but in Odin. This is a work in progress. It's not intended to be high performance, only to be a simple implementation to make me think about those problems and learn with them. To implement by myself simple versions of algorithms in different areas of knowledge, like:

- Mathematics
- Linear Algebra
- Numerical Methods
- Probability
- Statistics
- Optimization
- Physics
- Electronics
- DSP - Digital Signal Processing
- Audio Processing
- Image Processing
- RADAR and SAR Processing
- Tomography
- GeoPhysics
- Astronomy
- Computer Vision
- Machine Learning / Deep Learning

The sky, my imagination and my free time are the limit. I'm not a expert in any of this areas, but I'm a curious person and I like to learn new things. This is not intended to be useful to anybody and not to be high performance, only to be an exercise in learning using a cool language, Odin. 

## How to use MArray library
I have made extensive unit tests, and they are made to test from the outside and not from the inside of the library. So you can use them as examples, of how to use each function. The tests are made from a separate package. I have also added a lot of comments in the code for each function.

## Function convention

```
Method convention legend:
pxxxx( c )         <- Point operation, operation on each element of
                     the matrix, equivalent to Julia's ".+", ".-",
                     ".*" operations.
xxxx_a( c )       <- Allocates array MA< T >
xxxx_m( a, b )    <- Mutates a parameter array and returns a parameter
                     array MA< T >
xxxx_t( t, a, b ) <- Makes the operation and writes into parameter t
                     and returns parameter t array MA< T >
```

## License
MIT Open Source License

## Have fun
Best regards, <br>
João Carvalho <br> 

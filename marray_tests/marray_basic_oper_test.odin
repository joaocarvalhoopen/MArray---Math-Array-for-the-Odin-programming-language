// see `testing` package docs for things you can do with `testing.T`

// https://pkg.odin-lang.org/core/testing/

// Can see examples for the core math library in here:
// https://github.com/odin-lang/Odin/blob/master/tests/core/math/test_core_math.odin

// and run with "odin test . " // odin run some_package

// expect & expect_value are usually what you're after


// @(test)
// your_test_name :: proc(x: ^testing.T) {
//     // see `testing` package docs for things you can do with `testing.T`
// }

package marray_tests

// Normal API usage
// import ma "./marray"
import ma "./../marray"


// For testing only, inside package import usage like it was outside package.
// so into a namespace called ma.
// import ma "./"

import tc "core:testing"

import "core:fmt"
import "core:slice"
import "core:math"

// #########
// Test of the a simple NumPy, Julia or Matlab Math Array processing in Odin.


// Method convention legend:
// pxxx( c )         <- Point operation, operation on each element of the matrix,
//                      equaivalente to Julia's ".+", ".-", ".*" operations.
// xxxx_a( c )       <- Allocates array MA< T >
// xxxx_m( a, b )    <- Mutates a parameter array and returns a parameter array MA< T >
// xxxx_t( t, a, b ) <- Makes the operation and writes into parameter t and
//                      returns parameter t array MA< T >


// point apply mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// papply_m :: proc ( a : ^MA( $T ), b: MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T ) 

@(test)
test_papply_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    // Function to apply.
    func := proc ( a : f64, b: f64 ) -> f64 {
        return a + b
    }

    c := ma.papply_m( &a, b, func )

    correct_value: f64 = 2.5 + 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( a, d ) && ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// point apply into "t target", "a" and parameter "b",
// returning "t".
// papply_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T )

@(test)
test_papply_t_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.zeros_a( f64, []int{ 2, 3 } )
    defer ma.del( & c )


    // Function to apply.
    func := proc ( a : f64, b: f64 ) -> f64 {
        return a + b
    }
    

    h := ma.papply_t( & c, a, b, func )

    correct_value: f64 = 2.5 + 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( h, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( h ), ma.to_string_2d( d ) ) )
}


// ############################################################################
// ############################################################################


// point sum mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// psum_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_psum_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.psum_m( &a, b )

    correct_value: f64 = 2.5 + 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( a, d ) && ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// point sum into "t target", "a" and parameter "b",
// returning "t".
// psum_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

@(test)
test_psum_t_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.zeros_a( f64, []int{ 2, 3 } )
    defer ma.del( & c )


    h := ma.psum_t( & c, a, b )

    correct_value: f64 = 2.5 + 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( h, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( h ), ma.to_string_2d( d ) ) )
}

// point sub mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// psub_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_psub_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.psub_m( &a, b )

    correct_value: f64 = 2.5 - 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( a, d ) && ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// point sub into "t target", "a" and parameter "b",
// returning "t".
// psub_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

// point mul mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// pmul_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_pmul_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.pmul_m( &a, b )

    correct_value: f64 = 2.5 * 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// point mul into "t target", "a" and parameter "b",
// returning "t".
// pmul_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

// point div mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// pdiv_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_pdiv_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.pdiv_m( &a, b )

    correct_value: f64 = 2.5 / 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// point div into "t target", "a" and parameter "b",
// returning "t".
// pdiv_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

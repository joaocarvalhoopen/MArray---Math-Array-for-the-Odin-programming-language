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
// xxxx_a( c )       <- Allocates array MA< T >
// xxxx_m( a, b )    <- Mutates a parameter array and returns a parameter array MA< T >
// xxxx_t( t, a, b ) <- Makes the operation and writes into parameter t and returns parameter t array MA< T >


// apply mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// apply_m :: proc ( a : ^MA( $T ), b: MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T ) 

@(test)
test_apply_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    // Function to apply.
    func := proc ( a : f64, b: f64 ) -> f64 {
        return a + b
    }

    c := ma.apply_m( &a, b, func )

    correct_value: f64 = 2.5 + 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( a, d ) && ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// apply into "t target", "a" and parameter "b",
// returning "t".
// apply_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T )

@(test)
test_apply_t_001 :: proc(test: ^tc.T) {
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
    

    h := ma.apply_t( & c, a, b, func )

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


// Sum mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// sum_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_sum_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.sum_m( &a, b )

    correct_value: f64 = 2.5 + 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( a, d ) && ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// Sum into "t target", "a" and parameter "b",
// returning "t".
// sum_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

@(test)
test_sum_t_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.zeros_a( f64, []int{ 2, 3 } )
    defer ma.del( & c )


    h := ma.sum_t( & c, a, b )

    correct_value: f64 = 2.5 + 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( h, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( h ), ma.to_string_2d( d ) ) )
}

// sub mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// sub_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_sub_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.sub_m( &a, b )

    correct_value: f64 = 2.5 - 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( a, d ) && ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// sub into "t target", "a" and parameter "b",
// returning "t".
// sub_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

// mul mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// mul_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_mul_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.mul_m( &a, b )

    correct_value: f64 = 2.5 * 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// mul into "t target", "a" and parameter "b",
// returning "t".
// mul_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

// div mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
// div_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 

@(test)
test_div_m_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a := ma.create( f64, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f64, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.div_m( &a, b )

    correct_value: f64 = 2.5 / 1.5

    d := ma.create( f64, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( c, d ),
        fmt.tprintf("%s -> Marray espected :\n %s got :\n %s", 
                #procedure, ma.to_string_2d( d ), ma.to_string_2d( c ) ) )
}

// div into "t target", "a" and parameter "b",
// returning "t".
// div_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )

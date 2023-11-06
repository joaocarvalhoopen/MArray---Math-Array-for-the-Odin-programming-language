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

@(test)
test_gen_simple_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    a : ma.MA( f32 ) = ma.create( f32, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    
    b := ma.create( f32, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )

    c := ma.psum_m( & a, b )

    correct_value: f32 = 2.5 + 1.5

    d := ma.create( f32, []int{ 2, 3 }, correct_value ) 
    defer ma.del( & d )

    tc.expect(
        test,
        ma.equal( c, d ),
        fmt.tprintf("%s -> %s != %s", 
                #procedure, ma.to_string_1d( c ), ma.to_string_1d( d ) ) )

}


// ##########################################################################
// ##########################################################################
// ##########################################################################
// ##########################################################################


// Creation of a simple NumPy, Julia or Matlab Math Array processing in Odin.


// Method convention legend:
// xxxx_a( c )       <- Allocates array MA< T >
// xxxx_m( a, b )    <- Mutates a parameter array and returns a parameter array MA< T >
// xxxx_t( t, a, b ) <- Makes the operation and writes into parameter t and returns parameter t array MA< T >

/*

// For indexs
beg : int : 0
one : int : 1
end : int : bits.I64_MAX

// MType
EMT :: enum {
    INVALID,
	F16,      // f16
	F32,      // f32
	F64,      // f64 
	C32,      // complex32    (f16 + i * f16)
	C64,      // complex64    (f32 + i * f32)
	C128      // complex128   (f64 + i * f64)
}


// MA :: struct( $T : typeid )
// where T == f16 || T == f32 || T == f64 || T == complex32 || T == complex64 || T == complex128 { 

// With integers and float and complex
// MA :: struct( $T : typeid )
// where intrinsics.type_is_numeric( T ) {

// Without integers and with float and complex
// MA :: struct( $T : typeid )
// where intrinsics.type_is_numeric( T ) && !intrinsics.type_is_integer(T) {


// MArray
MA :: struct( $T : typeid )
where intrinsics.type_is_numeric( T ) {
    type  : EMT,
    dims  : int,
    sizes : [dynamic]int,
 	data  : [dynamic]T,    // real and imaginary
}

RaType :: enum  {
	single,
    double,
    three,
}

// Range val T where T is enum EMT
RaV :: struct ( $T : typeid )
where T == f16 || T == f32 || T == f64 || T == complex32 || T == complex64 || T == complex128 {
	type  : RaType,  
	start : T,
	step  : T,
	stop  : T
}

// Range Index
RaI :: struct  {
    r_type  : RaType,
	start : int,
	step  : int,
	stop  : int
}

*/


/*

ra_i_1 :: #force_inline proc ( start : int ) -> RaI 

ra_i_2 :: #force_inline proc ( start, stop : int ) -> RaI 

ra_i_3 :: #force_inline proc ( start, step, stop : int ) -> RaI 

ra_i :: proc { ra_i_1, ra_i_2, ra_i_3 }

*/


// Get the version of this Odin library.
// version :: #force_inline proc ( ) -> string 

@(test)
test_version_001 :: proc(test: ^tc.T) {
    // see `testing` package docs for things you can do with `testing.T`

    str_version := ma.version()

    str_version_expected := "0.0.1"

    tc.expect(
        test,
        str_version == str_version_expected,
        fmt.tprintf("%s -> %s != %s", 
                #procedure, str_version, str_version_expected ) )

}

// Returns the type of the array.
// get_type :: proc ( a : MA( $T ) ) -> EMT 

@(test)
test_get_type_001 :: proc(test: ^tc.T) {
    a := ma.create( f32, []int{ 2 }, 2.0 )
    defer ma.del( & a ) 

    str_type := ma.get_type( a )

    str_type_expected := ma.EMT.F32

    tc.expect(
        test,
        str_type == str_type_expected,
        fmt.tprintf("%s -> %v != %v", 
                #procedure, str_type, str_type_expected ) )

}

// Returns the number of dimensions.
// ndim :: proc ( a : MA( $T ) ) -> int 

@(test)
test_ndim_001 :: proc(test: ^tc.T) {
    a := ma.create( f32, []int{ 2, 5 }, 2.0 )
    defer ma.del( & a ) 

    str_ndim := ma.ndim( a )

    str_ndim_expected := 2

    tc.expect(
        test,
        str_ndim == str_ndim_expected,
        fmt.tprintf("%s -> %v != %v", 
                #procedure, str_ndim, str_ndim_expected ) )

}

// Returns the size of all dimensions.
// shape :: proc ( a : MA( $T ) ) -> []int

@(test)
test_shape_001 :: proc(test: ^tc.T) {
    a := ma.create( f32, []int{ 2, 5 }, 2.0 )
    defer ma.del( & a ) 

    str_shape := ma.shape( a )

    str_shape_expected := []int{ 2, 5 }

    tc.expect(
        test,
        slice.equal( str_shape, str_shape_expected ),
        fmt.tprintf("%s -> %v != %v", 
                #procedure, str_shape, str_shape_expected ) )

}

// Receives a type_of value and returns the type of the array.
// create_emt :: proc ( type : typeid ) -> EMT 

@(test)
test_create_emt_001 :: proc(test: ^tc.T) {
    emt := ma.create_emt( f32 )

    emt_expected := ma.EMT.F32

    tc.expect(
        test,
        emt == emt_expected,
        fmt.tprintf("%s -> %v != %v", 
                #procedure, emt, emt_expected ) )

}

@(test)
test_create_emt_002 :: proc(test: ^tc.T) {
    emt := ma.create_emt( complex64 )

    emt_expected := ma.EMT.C64

    tc.expect(
        test,
        emt == emt_expected,
        fmt.tprintf("%s -> %v != %v", 
                #procedure, emt, emt_expected ) )

}

// Creates a MArray with the type and the values of the given slice.
// create_1 :: proc ( a : []$T ) -> MA( T ) 

@(test)
test_create_1_001 :: proc(test: ^tc.T) {
    my_slice := []f64{ 0.0, 1.1, 2.2 }
    
    a := ma.create( my_slice )
    defer ma.del( & a ) 

    str_shape := ma.shape( a )

    str_shape_expected := []int{ 3 }

    slices_are_equal := slice.equal( a.data[:], my_slice )

    tc.expect(
        test,
        slice.equal( str_shape, str_shape_expected ) && slices_are_equal &&  a.dims == 1 && a.type == ma.EMT.F64,
        fmt.tprintf("%s -> %v != %v, slices_are_equals: %v", 
                #procedure, str_shape, str_shape_expected, slices_are_equal ) )

}

// Creates a N Dimension MArray with the type and the values of the given slice.
// create_2 :: proc ( a : []$T, sizes : []int ) -> MA( T ) 

@(test)
test_create_2_001 :: proc(test: ^tc.T) {
    my_slice := []f64{ 0.0, 1.1, 2.2, 3.3, 4.4, 5.5 }
    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_slice, my_sizes )
    defer ma.del( & a ) 

    str_shape := ma.shape( a )

    str_shape_expected := my_sizes

    slices_are_equal := slice.equal( a.data[:], my_slice )

    tc.expect(
        test,
        slice.equal( str_shape, str_shape_expected ) && slices_are_equal &&  a.dims == 2 && a.type == ma.EMT.F64,
        fmt.tprintf("%s -> %v != %v, slices_are_equals: %v", 
                #procedure, str_shape, str_shape_expected, slices_are_equal ) )

}

// create_3 :: proc ( $T : typeid, /* dims: int, */ sizes : []int, value : T  = T{} ) -> MA( T ) 
// where T == f16 || T == f32 || T == f64 || T == complex32 || T == complex64 || T == complex128

// With integers
// create_3 :: proc ( $T : typeid, /* dims: int, */ sizes : []int, value : T  = T{} ) -> MA( T ) 
// where intrinsics.type_is_numeric( T ) {

// Without integers
// create_3 :: proc ( $T : typeid, /* dims: int, */ sizes : []int, value : T  = T{} ) -> MA( T ) 
// where intrinsics.type_is_numeric( T ) && !intrinsics.type_is_integer(T) {



// Creates a N Dimension MArray with the type specified and with all the values equal to the value parameter.
// create_3 :: proc ( $T : typeid, sizes : []int, value : T  = T{} ) -> MA( T ) 

@(test)
test_create_3_001 :: proc(test: ^tc.T) {
    my_slice := []f64{ 2.3, 2.3, 2.3, 2.3, 2.3, 2.3 }
    my_sizes := []int{ 2, 3 }
    
    a := ma.create( f64, my_sizes, 2.3 )
    defer ma.del( & a ) 

    str_shape := ma.shape( a )

    str_shape_expected := my_sizes

    slices_are_equal := slice.equal( a.data[:], my_slice )

    tc.expect(
        test,
        slice.equal( str_shape, str_shape_expected ) && slices_are_equal &&  a.dims == 2 && a.type == ma.EMT.F64,
        fmt.tprintf("%s -> %v != %v, slices_are_equals: %v", 
                #procedure, str_shape, str_shape_expected, slices_are_equal ) )

}

// Creates a N Dimension MArray with the type specified and with all the
// values in integer sequence, ascending or descending.
// create_4 :: proc ( $T : typeid, sizes : []int, val_order_ascending : bool ) -> MA( T )

@(test)
test_create_4_001 :: proc(test: ^tc.T) {
    my_slice := []f64{ 0, 1, 2, 3, 4, 5 }
    my_sizes := []int{ 2, 3 }
    
    values_ascending_order := true
    a := ma.create( f64, my_sizes, values_ascending_order )
    defer ma.del( & a ) 

    str_shape := ma.shape( a )

    str_shape_expected := my_sizes

    slices_are_equal := slice.equal( a.data[:], my_slice )

    // fmt.println( a.data[:] )
    // fmt.println( ma.to_string_2d( a ) )

    tc.expect(
        test,
        slice.equal( str_shape, str_shape_expected ) && slices_are_equal &&  a.dims == 2 && a.type == ma.EMT.F64,
        fmt.tprintf("%s -> %v != %v, slices_are_equals: %v", 
                #procedure, str_shape, str_shape_expected, slices_are_equal ) )

}

// create :: proc { create_1, create_2, create_3 }


// Deletes the MArray allocated memory.
// del :: proc ( a : MA( $T ) ) 

// ex:
//
// b = ma.create( [ 0.0, 0.1, 0.2 ] )
// ma.del( b )

@(test)
test_del_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }
    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    
    res_sizes_equal := slice.equal( a.sizes[:], my_sizes )
    res_data_equal := slice.equal( a.data[:], my_data )
    
    ma.del( & a ) 

    tc.expect(
        test,
        res_sizes_equal &&
             res_data_equal  &&
             a.data == nil   &&
             a.sizes == nil  &&
             a.dims == 0     &&
             a.type == ma.EMT.INVALID,
        fmt.tprintf("%s -> deleted, gives error after deleted,\n %v", 
                #procedure, ma.to_string( a ) ) )
}

// Tests if the  MA arrays are equal.
// equal :: proc ( a : MA( $T ), b : MA( T ) ) -> bool 

@(test)
test_equal_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }
    my_data_2  := []f64{ 0, 1, 2, 3, 4, 5, 7, 7 }

    my_sizes := []int{ 2, 3 }
    my_sizes_2 := []int{ 2, 4 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    b := ma.create( my_data, my_sizes )
    defer ma.del( & b )

    c := ma.create( my_data_2, my_sizes_2 )
    defer ma.del( & c )

    res_sizes_equal := slice.equal( a.sizes[:], my_sizes )
    res_data_equal  := slice.equal( a.data[:], my_data )
  
    res_operation := ma.equal( a, b )
    
    res_operation_2 := ma.equal( a, c )

    tc.expect(
        test,
        res_sizes_equal &&
             res_data_equal  &&
             res_operation   &&   // The a, and b are equal.
             !res_operation_2,    // The a, and c are not equal.
        fmt.tprintf("%s -> a == b and a != c\n equals( a, b ) :  %v\n equals( a, c ) :  %v", 
                #procedure, res_operation, res_operation_2 ) )
}

// Generates a string with the array representation of the contents of a slice.
// slice_to_string :: proc( slice_p: []$T ) -> string 

@(test)
test_slice_to_string_001 :: proc(test: ^tc.T) {
    my_slice  := []f64{ 0, 1, 2 }
    
    res_str := ma.slice_to_string( my_slice )

    res_str_expected := "[ 0.000, 1.000, 2.000 ]"

    // fmt.println( res_str )

    tc.expect(
        test,
        res_str == res_str_expected,
        fmt.tprintf("%s -> expected:\n %v\n got:\n %v", 
                #procedure, res_str_expected, res_str ) )
}

// to_string() of a 1 D array.
// to_string_1d ::proc ( a : MA( $T ) ) -> string 

@(test)
test_to_string_1d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2 }

    my_sizes := []int{ 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 
  
    res_str := ma.to_string( a )

    res_str_expected := "MA{ type: F64, dims: 1, sizes: [ 3 ], data: [ 0.000, 1.000, 2.000 ] }"
    
    tc.expect(
        test,
        res_str == res_str_expected,
        fmt.tprintf("%s -> \n expected string:\n % v \n\n to_string_1d( a ): \n %v", 
                #procedure, res_str_expected, res_str ) )
}

// to_string() of a 2 D array.
//
// NOTE(jnc): If dims greater then 3,
//            then print only the first 2 dimensions/elements,
//            Then ...
//            Then the last dimention. 
//            Each dimension is also limited to the first 3 values and the last 2 values.
// to_string_2d ::proc ( a : MA( $T ) ) -> string 

@(test)
test_to_string_2d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }

    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 
  
    res_str := ma.to_string( a )

    res_str_expected := "MA{ type: F64, dims: 2, sizes: [ 2, 3 ], data: \n[ [ 0.000, 1.000, 2.000 ]\n  [ 3.000, 4.000, 5.000 ] ] }"
    
    tc.expect(
        test,
        res_str == res_str_expected,
        fmt.tprintf("%s -> \n expected string:\n % v \n\n to_string_2d( a ): \n %v", 
                #procedure, res_str_expected, res_str ) )
}

// to_string() of a 3 D array.
//
// NOTE(jnc): If dims greater then 3,
//            then print only the first 2 dimensions/elements,
//            Then ...
//            Then the last dimention. 
//            Each dimension is also limited to the first 3 values and the last 2 values.
// to_string_3d ::proc ( a : MA( $T ) ) -> string 


// TODO(jnc) - I have to come back to this one to correct it!
@(test)
test_to_string_3d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }

    my_sizes := []int{ 2, 2, 5 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 
  
    res_str := ma.to_string( a )

    res_str_expected := `MA{ type: F64, dims: 3, sizes: [ 2, 2, 5 ], data: 
[ [ [ 0.000, 1.000, 2.000, ..., 4.000 ]
    [ 5.000, 6.000, 7.000, ..., 9.000 ] ]

  [ [ 10.000, 11.000, 12.000, ..., 14.000 ]
    [ 15.000, 16.000, 17.000, ..., 19.000 ] ] ] }`
    
    tc.expect(
        test,
        res_str == res_str_expected,
        fmt.tprintf("%s -> \n expected string:\n % v \n\n to_string_3d( a ): \n %v", 
                #procedure, res_str_expected, res_str ) )
}

// to_string() of a N Dimensional array.
// to_string_nd ::proc ( a : MA( $T ) ) -> string 

@(test)
test_to_string_nd_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3 }

    my_sizes := []int{ 1, 2, 2, 1 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 
  
    res_str := ma.to_string( a )

    res_str_expected := "MA{ type: F64, dims: 4, sizes: [ 1, 2, 2, 1 ],\n data: Can't print a N Dimensional array! }"
    
    tc.expect(
        test,
        res_str == res_str_expected,
        fmt.tprintf("%s -> \n expected string:\n % v \n\n to_string_nd( a ): \n %v", 
                #procedure, res_str_expected, res_str ) )
}

// to_string ::proc ( a : MA( $T ) ) -> string 

// Get the 1D linear position of a mapped 2D arrays.
// Odin like C is Raw major, so we also will be Raw major inside MArray.
// index_2d :: #force_inline proc ( i, j, size_j : int ) -> int

@(test)
test_index_2d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }

    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    res_data := make( [dynamic]f64, 0, 6 )
    defer delete( res_data )

    flag_no_error := true 
    ind_1d := 0

    // Test if they are equal in the same order.
    fmt.printf( "[ " )
    for i in 0 ..< a.sizes[0] {
        for j in 0 ..< a.sizes[1] {
            ind_2d := ma.index_2d( i, j, a.sizes[1] )
            fmt.printf( "%v", ind_2d )
            if ind_1d != ind_2d {
                flag_no_error = false
            }
            append( & res_data, a.data[ ind_2d ] )

            ind_1d += 1
        }
    }
    fmt.printf( " ]" )

    res_equal := slice.equal( res_data[:], my_data ) 
    
    tc.expect(
        test,
        res_equal,
        fmt.tprintf("%s -> %v\n expected:\n %v\n got:\n %v\n", 
            #procedure,
            res_equal && flag_no_error,
            ma.slice_to_string( my_data ),
            ma.slice_to_string( res_data[:] ) ) )
}

// Get the 1D linear position of a mapped 3D arrays.
// Odin like C is Raw major, so we also will be Raw major inside MArray.
// index_3d :: #force_inline proc ( i, j, k, size_j, size_k : int ) -> int 

@(test)
test_index_3d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }

    my_sizes := []int{ 2, 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    res_data := make( [dynamic]f64, 0, 12 )
    defer delete( res_data )

    flag_no_error := true 
    ind_1d := 0

    // Test if they are equal in the same order.
    fmt.printf( "[ " )
    for i in 0 ..< a.sizes[0] {
        for j in 0 ..< a.sizes[1] {
            for k in 0 ..< a.sizes[2] {
                ind_3d := ma.index_3d( i, j, k, a.sizes[1], a.sizes[2] )
                fmt.printf( "%v", ind_3d )
                if ind_1d != ind_3d {
                    flag_no_error = false
                }
                append( & res_data, a.data[ ind_3d ] )

                ind_1d += 1
            }
        }
    }
    fmt.printf( " ]" )

    res_equal := slice.equal( res_data[:], my_data ) 
    
    tc.expect(
        test,
        res_equal && flag_no_error,
        fmt.tprintf("%s -> %v\n expected:\n %v\n got:\n %v\n", 
            #procedure,
            res_equal,
            ma.slice_to_string( my_data ),
            ma.slice_to_string( res_data[:] ) ) )
}

// Creates a Zero Matrix of the specified N Dimensions.
// A Zero Matrix has all element equal to zero.
// zeros_a :: proc ( $T : typeid, dims: int, sizes : []int ) -> MA( T ) 

@(test)
test_zeros_a_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 0, 0, 0, 0, 0 }

    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    b := ma.zeros_a( f64, my_sizes )
    defer ma.del( & b ) 

    res_equal := ma.equal( a, b )

    // fmt.printf( "a: %v\n", ma.to_string( a ) )

    tc.expect(
        test,
        res_equal,
        fmt.tprintf("%s -> res_equal %v\n %v", 
            #procedure,
            res_equal,
            ma.to_string( a )
            ) )
}

// Creates a One Matrix of the specified N Dimensions.
// A One Matrix has all element equal to zero.
// ones_a :: proc ( $T : typeid, dims: int, sizes : []int ) -> MA( T ) 

@(test)
test_ones_a_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 1, 1, 1, 1, 1, 1 }

    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    b := ma.ones_a( f64, my_sizes )
    defer ma.del( & b ) 

    res_equal := ma.equal( a, b )

    // fmt.printf( "a: %v\n", ma.to_string( a ) )

    tc.expect(
        test,
        res_equal,
        fmt.tprintf("%s -> res_equal %v\n %v", 
            #procedure,
            res_equal,
            ma.to_string( a )
            ) )
}

// Generate a 1D MArray with the values of the given range and the increment.
// arange_a :: proc (  $T : typeid, start : T, step : T, stop : T ) -> MA( T ) 

// ex:
//
// b = MA.arange( 0.0, 0.1, 10.0 )

@(test)
test_arange_a_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }

    my_sizes := []int{ 6 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    b := ma.arange_a( f64, 0, 1, 5 )
    defer ma.del( & b ) 

    res_equal := ma.equal( a, b )

    // fmt.printf( "a: %v\n", ma.to_string( a ) )

    tc.expect(
        test,
        res_equal,
        fmt.tprintf("%s -> res_equal %v\n MArray espected : %v\n MArray got : %v", 
            #procedure,
            res_equal,
            ma.to_string( a ),
            ma.to_string( b )  ) )
}

// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
// is_coord_inbound :: #force_inline proc ( a : MA( $T ), ch: rune, index : int, ind_len : int ) -> int 

@(test)
test_is_coord_inbound_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2 }

    my_sizes := []int{ 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    // Correct indexes
    index_original := []int{ 0, 1, 2, -1, -2, -3 }
    index_target   := []int{ 0, 1, 2,  2,  1,  0 }

    for i in 0 ..< len( index_original ) {
        res_index, error, error_msg := ma.is_coord_inbound( a, 0,
                                           index_original[ i ] )
        tc.expect(
            test,
            res_index == index_target[ i ] && !error,
            fmt.tprintf("%s -> res_index %v    MArray espected : %v    MArray got : %v", 
                #procedure,
                res_index,
                index_original[ i ],
                index_target[ i ] ) )
    }

    // Incorrect indexes
    index_orig_with_error := []int{ 3, 4, -4, -5 }
    // index_target   := []int{ 0, 1, 2,  2,  1,  0 }

    for i in 0 ..< len( index_orig_with_error ) {
        res_index, error, error_msg := ma.is_coord_inbound( a, 0,
                                            index_orig_with_error[ i ] )
        tc.expect(
            test,
            error,
            fmt.tprintf("%s -> res_index %v    MArray parameter index: %v    MArray index error : %v", 
                #procedure,
                res_index,
                index_orig_with_error[ i ],
                error ) )
    }

}

// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
// get_1d :: #force_inline proc ( a : MA( $T ), ind_i : int ) -> T 

@(test)
test_get_1d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2 }

    my_sizes := []int{ 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    // Correct indexes
    index_original := []int{ 0, 1, 2, -1, -2, -3 }
    index_target   := []f64{ 0, 1, 2,  2,  1,  0 }

    for i in 0 ..< len( index_original ) {
        res_index /* , error, error_msg */ := ma.get_1d( a, index_original[ i ] )
        tc.expect(
            test,
            res_index == index_target[ i ] /* && !error */ ,
            fmt.tprintf("%s -> res_index %v    MArray espected : %v    MArray got : %v", 
                #procedure,
                res_index,
                index_original[ i ],
                index_target[ i ] ) )
    }

    // Incorrect indexes
    // If this are run it will panic and end the test.
    // index_orig_with_error := []int{ 3, 4, -4, -5 }

    // for i in 0 ..< len( index_orig_with_error ) {
    //      _ /* _res_index */ = ma.get_1d( a, index_orig_with_error[ i ] )
    // }

}

// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
// get_2d :: #force_inline proc ( a : MA( $T ), ind_i, ind_j : int ) -> T 

@(test)
test_get_2d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }

    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    /*
    
    Tuple :: struct( $T : typeid, $V : typeid)
    where T == V {
        i : T,
        j : V,
    }

    Tu :: Tuple(int, int)

    index_orig_i_j := []Tuple( int, int ){ Tu{ 0 , 0 }, Tu{ 0, 1 }, Tu{ 0, 2 }, Tu{ 1 , 0 }, Tu{ 1, 1 }, Tu{ 1, 2 } }
    
    */

    // Correct indexes
    index_orig_i := []int{ 0, 1 }
    index_orig_j := []int{ 0, 1, 2 }
    // index_target := []f64{ 0, 1, 2, 3, 4, 5 }

    index_accu := 0

    // for Tuple{ i, j } in index_orig_i_j {
    for i in index_orig_i {
        for j in index_orig_j {

            res_value := ma.get_2d( a, i, j )
            expected_value := my_data[ index_accu ]
            
            tc.expect(
                test,
                expected_value == res_value,
                fmt.tprintf("%s -> [ %v,  %v ]  value espected : %v    value got : %v", 
                    #procedure,
                    i,
                    j,
                    expected_value,
                    res_value ) )
            index_accu += 1
        }
    }

}

// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
// get_3d :: #force_inline proc ( a : MA( $T ), ind_i, ind_j, ind_k : int ) -> T 

@(test)
test_get_3d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }

    my_sizes := []int{ 2, 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    // Correct indexes
    index_orig_i := []int{ 0, 1 }
    index_orig_j := []int{ 0, 1 }
    index_orig_k := []int{ 0, 1, 2 }
    
    index_accu := 0

    // for Tuple{ i, j } in index_orig_i_j {
    for i in index_orig_i {
        for j in index_orig_j {
            for k in index_orig_k {
                res_value      := ma.get_3d( a, i, j, k )
                expected_value := my_data[ index_accu ]
                
                tc.expect(
                    test,
                    expected_value == res_value,
                    fmt.tprintf("%s -> [ %v,  %v, %v ]  value espected : %v    value got : %v", 
                        #procedure,
                        i,
                        j,
                        k,
                        expected_value,
                        res_value ) )
                index_accu += 1
            }
        }
    }

}

// get :: proc { get_1d, get_2d, get_3d }


// TODO(jnc): Implement th e following test and the function to be tested!

// get( a : MA< T >, ind_i, ind_j, ind_k, int_a : int, ... ) -> T   // Variable num arguments


// TODO(jnc): Implement th e following test and the function to be tested!

// RANGE
// Allocates.
// get_a( a : MA< T >, a : []Range ) -> a : MA< T >  

/*

// Question?
// How to I implement this case: 
// print(arr[0:2, 2]) 
// One coordenate is a range the other is fixed.

ex: 

a = ones( f32, [10, 20] )

// Allocates
b = get_a( a, [ [1, 0, 3], [1] ] )

b = get_a( a, [ [1, 0, 3], 1 ] )     // I think that this doesn't work in Odin.

MA_del( a )
MA_del( b )

*/

// Supports negative indexes, that are mapped from the end of the vector "val = set(a, 3, -1)"
// set_m_1d :: #force_inline proc ( a : MA( $T ), value : T, ind_i : int ) -> T 

@(test)
test_set_m_1d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 9, 9, 9 }

    my_sizes := []int{ 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    // Correct indexes
    index_original := []int{ 0, 1, 2, -1, -2, -3 }
    index_target   := []f64{ 0, 1, 2,  2,  1,  0 }
    
    for i in 0 ..< len( index_original ) {
        index := index_original[ i ]
        ma.set_m( a, index_target[ i ], index )
        res_value := ma.get_1d( a, index )
        tc.expect(
            test,
            res_value == index_target[ i ],
            fmt.tprintf("%s -> index %v    MArray espected : %v    MArray got : %v", 
                #procedure,
                index,
                index_target[ i ],
                res_value ) )
    }

    // Incorrect indexes
    // If this are run it will panic and end the test.
    //
    // index_orig_with_error := []int{ 3, 4, -4, -5 }
    //
    // for i in 0 ..< len( index_orig_with_error ) {
    //     ma.set_m_1d( a, 1, index_orig_with_error[ i ] )
    // }

}

// Supports negative indexes, that are mapped from the end of the vector "val = set(a, 3, -1)"
// set_m_2d :: #force_inline proc ( a : MA( $T ), value: T, ind_i, ind_j : int ) -> T 

@(test)
test_set_m_2d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 9, 9, 9, 9, 9, 9 }

    my_sizes := []int{ 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    // Correct indexes
    index_orig_i := []int{ 0, 1 }
    index_orig_j := []int{ 0, 1, 2 }
    index_target := []f64{ 0, 1, 2, 3, 4, 5 }

    index_accu := 0

    for i in index_orig_i {
        for j in index_orig_j {

            value_to_set := index_target[ index_accu ]

            ma.set_m_2d( a, value_to_set, i, j )
            res_value := ma.get_2d( a, i, j )
            expected_value := index_target[ index_accu ]
            
            tc.expect(
                test,
                expected_value == res_value,
                fmt.tprintf("%s -> [ %v,  %v ]  value espected : %v    value got : %v", 
                    #procedure,
                    i,
                    j,
                    expected_value,
                    res_value ) )
            index_accu += 1
        }
    }

}

// Supports negative indexes, that are mapped from the end of the vector "val = set(a, 3, -1)"
// set_m_3d :: #force_inline proc ( a : MA( $T ), value: T, ind_i, ind_j, ind_k : int ) -> T 

@(test)
test_set_m_3d_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 }

    my_sizes := []int{ 2, 2, 3 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    // Correct indexes
    index_orig_i := []int{ 0, 1 }
    index_orig_j := []int{ 0, 1 }
    index_orig_k := []int{ 0, 1, 2 }
    index_target := []f64{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }

    index_accu := 0

    for i in index_orig_i {
        for j in index_orig_j {
            for k in index_orig_j {

                value_to_set := index_target[ index_accu ]

                ma.set_m_3d( a, value_to_set, i, j, k )
                res_value := ma.get_3d( a, i, j, k )
                expected_value := index_target[ index_accu ]
                
                tc.expect(
                    test,
                    expected_value == res_value,
                    fmt.tprintf("%s -> [ %v,  %v, %v ]  value espected : %v    value got : %v", 
                        #procedure,
                        i,
                        j,
                        k,
                        expected_value,
                        res_value ) )
                index_accu += 1
            }
        }
    }

}

// set_m :: proc { set_m_1d, set_m_2d, set_m_3d }


// TODO(jnc): Implement th e following test and the function to be tested!

// set_m() 4 D and more variable num arguments
// set_m :: #force_inline proc ( a : MA( $T ), value: T, ind_i, ind_j, ind_k, int a : int, ...  ) -> T 


// TODO(jnc): Implement th e following test and the function to be tested!
 
// Allocates
// RANGE
// set( a : MA< T >, val : T, a : []Range )


// Allocates
// copy_a :: proc ( a : MA( $T ) ) -> MA( T ) 

@(test)
test_copy_a_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }

    my_sizes := []int{ 6 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    b := ma.copy_a( a )
    defer ma.del( & b ) 

    res_equal := ma.equal( a, b )

    // fmt.printf( "a: %v\n", ma.to_string( a ) )

    tc.expect(
        test,
        res_equal,
        fmt.tprintf("%s -> res_equal %v\n MArray espected : %v\n MArray got : %v", 
            #procedure,
            res_equal,
            ma.to_string( a ),
            ma.to_string( b )  ) )
}

// Change the shape of the matrix, mantaining all elements and it's number.
// Doesn't change the data elements.
// reshape_m :: proc ( a : MA( $T ), new_sizes : []int ) -> MA( T ) 

@(test)
test_reshape_m_001 :: proc(test: ^tc.T) {
    my_data  := []f64{ 0, 1, 2, 3, 4, 5 }

    my_sizes := []int{ 6 }
    
    a := ma.create( my_data, my_sizes )
    defer ma.del( & a ) 

    b := ma.create( my_data, my_sizes )
    defer ma.del( & b ) 

    new_sizes := []int{ 2, 3 }
    ma.reshape_m( &b, new_sizes )

    res_equal := a.type == b.type && 
                 a.dims != b.dims &&
                 b.dims == len( new_sizes ) &&  
                 !slice.equal(a.sizes[:], b.sizes[:] ) &&
                 slice.equal( b.sizes[:], new_sizes ) &&
                 slice.equal( a.data[:], b.data[:] ) 

    // fmt.printf( "a: %v\n", ma.to_string( a ) )
    // fmt.printf( "a: %v\n", ma.to_string( b ) )

    tc.expect(
        test,
        res_equal,
        fmt.tprintf("%s -> res_equal %v\n MArray espected : %v\n MArray got : %v", 
            #procedure,
            res_equal,
            ma.to_string( a ),
            ma.to_string( b )  ) )
}


/*

example:

You are allowed to have one "unknown" dimension.
Meaning that you do not have to specify an exact number for one of the dimensions in the reshape method.
Pass -1 as the value, and NumPy will calculate this number for you.

Flattening array means converting a multidimensional array into a 1D array.

We can use reshape(-1) to do this.

arr = np.array([[1, 2, 3], [4, 5, 6]])

newarr = arr.reshape(-1)

*/





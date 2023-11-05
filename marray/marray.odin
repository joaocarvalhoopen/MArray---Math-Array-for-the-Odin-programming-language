// Library name: MArray - Math Array for the Odin programming language.
// Version: 0.0.1
// Description : Creation of a simple version inspired on NumPy, Julia or Matlab
//               math array processing kind of tools, but in Odin.
//               This is a work in progress.
//               It's not intended to be high performance, only to be a
//               simple implementation to make me think about those problems and
//               and learn with them.
//               To implement by myself simple versions of algorithms in different
//               areas of knowledge, like:
//                 - Mathematics
//                 - Linear Algebra
//                 - Numerical Methods
//                 - Probability
//                 - Statistics
//                 - Optimization
//                 - Physics
//                 - Electronics
//                 - DSP - Digital Signal Processing
//                 - Audio Processing
//                 - Image Processing
//                 - RADAR and SAR Processing
//                 - Tomography
//                 - GeoPhysics
//                 - Astronomy
//                 - Computer Vision
//                 - Machine Learning / Deep Learning
//               The sky, my imagination and my free time are the limit.
//               I'm not a expert in any of this areas, but I'm a curious
//               person and I like to learn new things. 
//
// How to use MArray library: I have made extensive unit tests, and they are made
//                            to test from the outside and not from the inside
//                            of the library. So you can use them as examples, of
//                            how to use each function.
//                            The tests are made from a separate package.
//                            I have also added a lot of comments in the code for
//                            each function.
//
// Author :  João Carvalho 
// Date :    2023-11-04
// License : MIT Open Source License
//


package marray

import "core:strings"
import "core:intrinsics"
import "core:slice"
import "core:math"
import "core:math/bits"
import "core:mem"
import "core:fmt"
import "core:runtime"

// Creation of a simple NumPy, Julia or Matlab Math Array processing in Odin.


// Method convention legend:
// xxxx_a( c ) -> a        <- Allocates array MA< T >
// xxxx_m( a, b ) -> a     <- Mutates a parameter array and returns a parameter array MA< T >
// xxxx_t( t, a, b ) -> t  <- Makes the operation and writes into parameter t and returns parameter t array MA< T >


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

ra_i_1 :: #force_inline proc ( start : int ) -> RaI {
    return RaI{ r_type = RaType.single, start = start, step = 0, stop = 0 }
} 

ra_i_2 :: #force_inline proc ( start, stop : int ) -> RaI {
    return RaI{ r_type = RaType.double, start = start, step = 0, stop = stop }
} 

ra_i_3 :: #force_inline proc ( start, step, stop : int ) -> RaI {
    return RaI{ r_type = RaType.three, start = start, step = step, stop = stop }
} 

ra_i :: proc { ra_i_1, ra_i_2, ra_i_3 }

// Returns the version of this package.
version :: #force_inline proc ( ) -> string {
    return "0.0.1"
}

// Returns the type of the array.
get_type :: proc ( a : MA( $T ) ) -> EMT {
    return a.type
}

// Returns the number of dimensions.
ndim :: proc ( a : MA( $T ) ) -> int {
    return a.dims
}

// Returns the size of all dimensions.
shape :: proc ( a : MA( $T ) ) -> []int {
    return a.sizes[:]
}

// Receives a type_of value and returns the type of the array.
create_emt :: proc ( type : typeid ) -> EMT {
    switch type {
        case f16: return EMT.F16
        case f32: return EMT.F32
        case f64: return EMT.F64
        case complex32: return EMT.C32
        case complex64: return EMT.C64
        case complex128: return EMT.C128
        case : panic( "Invalid type." )
    }
}

// Creates a 1D MArray with the type and the values of the given slice.
create_1 :: proc ( slice_p : []$T ) -> MA( T ) {
    res := MA( T ) {
        type = create_emt( T ),
        dims = 1,
        sizes = make( [dynamic]int, len=0, cap=1 ),
        data = slice.clone_to_dynamic( slice_p ),
    }

    // Copy the 1D size to the dynamic array.
    append( &res.sizes, len( slice_p) )

    // Copy the slice elements to the dynamic array.
    // slice.fill( res.data[:], slice_p )

    return res
}

// Creates a N Dimension MArray with the type and the values of the given slice.
create_2 :: proc ( slice_p : []$T, sizes : []int ) -> MA( T ) {
    
    // Test if sizes are valid
    // Test if sizes are valid
    mul_dim_len : int = 1
    for i in sizes {
        if i <= 0 {
            panic( "Zero or negative size in array creation." )
        }
        mul_dim_len *= i
    }
    len_slice_p := len( slice_p )
    if mul_dim_len != len_slice_p {
        panic( "The number of elements in the array is different from the number of elements in the sum of the sizes array in the parameter." )
    }

    res := MA( T ) {
        type  = create_emt( T ),
        dims  = len( sizes),
        sizes = slice.clone_to_dynamic( sizes ),
        data  = slice.clone_to_dynamic( slice_p ),
    }

    // Copy the 1D size to the dynamic array.
    // append( &res.sizes, len( slice_p) )

    // Copy the slice elements to the dynamic array.
    // slice.fill( res.data[:], slice_p )

    return res
}

// make_3 :: proc ( $T : typeid, /* dims: int, */ sizes : []int, value : T  = T{} ) -> MA( T ) 
// where T == f16 || T == f32 || T == f64 || T == complex32 || T == complex64 || T == complex128

// With integers
// make_3 :: proc ( $T : typeid, /* dims: int, */ sizes : []int, value : T  = T{} ) -> MA( T ) 
// where intrinsics.type_is_numeric( T ) {

// Without integers
// make_3 :: proc ( $T : typeid, /* dims: int, */ sizes : []int, value : T  = T{} ) -> MA( T ) 
// where intrinsics.type_is_numeric( T ) && !intrinsics.type_is_integer(T) {

// Creates a N Dimension MArray with the type specified and with all the values equal to the value parameter.
create_3 :: proc ( $T : typeid, sizes : []int, value : T ) -> MA( T )  {

    // Test if sizes are valid
    mul_dim_len : int = 1
    for i in sizes {
        if i <= 0 {
            panic( "Zero or negative size in array creation." )
        }
        mul_dim_len *= i
    }

    // I beleave that this works
    // sizes_tmp := [ dynamic ]int{}
    // append( &sizes_tmp, ..sizes ) // append a slice

    // Note(jnc): Is there a simple way (one liner) of creating a dynamic array
    //            from a slice that is allocated on the stack?
    // sizes : []int{ 0, 1, 2, 3 }
    // sizes_tmp = [dynamic]int{ sizes },


    // Allocates
    a : MA( T ) = MA( T ) {
        type = create_emt( T ),
        dims = len( sizes ),
        // sizes = make( [ dynamic ]int, len( sizes ) ),
        sizes = slice.clone_to_dynamic( sizes ),
        data = make( [ dynamic ]T, mul_dim_len ),
    }

    // append( &a.sizes, ..sizes )

    // Fill with value the dynamic array as a slice.
    slice.fill( a.data[:], value )
    
    return a
}

// Creates a N Dimension MArray with the type specified and with all the
// values in integer sequence, ascending or descending.
create_4 :: proc ( $T : typeid, sizes : []int, values_ascending_order : bool ) -> MA( T ) {

    // Test if sizes are valid
    mul_dim_len : int = 1
    for i in sizes {
        if i <= 0 {
            panic( "Zero or negative size in array creation." )
        }
        mul_dim_len *= i
    }

    val  : T = 0
    step : T = 1
    if !values_ascending_order {
        val : T = T( mul_dim_len ) - 1
        step : T = -1
    }

    // Allocates
    res : MA( T ) = MA( T ) {
        type  = create_emt( T ),
        dims  = len( sizes ),
        sizes = slice.clone_to_dynamic( sizes ),
        data  = make( [ dynamic ]T, len=0, cap=mul_dim_len ),
    }

    // append( &a.sizes, ..sizes )

    // Fill with values in the data dynamic array ascending or descending.
    for i in 0 ..< mul_dim_len {
        append( &res.data, val )
        val += step
    }

    return res
}

create :: proc { create_1, create_2, create_3, create_4 }

// Deletes the MArray allocated memory.
del :: proc ( a : ^MA( $T ) ) {
    a := a
    a.type = EMT.INVALID
    a.dims = 0  
    delete( a.sizes )
    a.sizes = nil
    delete( a.data )
    a.data = nil
}

/*
ex:

b = ma.create( [ 0.0, 0.1, 0.2 ] )

ma.del( b )

*/

// Tests if the 2 MArrays are equal.
equal :: proc ( a : MA( $T ), b : MA( T ) ) -> bool {
    if a.type != b.type {
        return false
    }
    if a.dims != b.dims {
        return false
    }
    if !slice.equal( a.sizes[:], b.sizes[:] ) {
        return false
    }
    if !slice.equal( a.data[:], b.data[:] ) {
        return false
    }
    return true
}

// Generates a string with the array representation of the contents of a slice.
slice_to_string :: proc( slice_p: []$T ) -> string {
    str_builder := strings.builder_make( len=0, cap=100 )
    fmt.sbprint( &str_builder,  "[ " )
    for i in 0 ..< len( slice_p ) {
        if i == 0 {
            fmt.sbprintf( &str_builder,  "%v", slice_p[ i ] )
        } else {
            fmt.sbprintf( &str_builder, ", %v", slice_p[ i ] )
        }
    }
    fmt.sbprintf( &str_builder,  " ]" )
    return strings.to_string( str_builder )
}    

// to_string() of a 1 D array.
to_string_1d ::proc ( a : MA( $T ) ) -> string {
    str_sizes := slice_to_string( a.sizes[:] )
    defer delete( str_sizes )

    str_data := slice_to_string( a.data[:] )
    defer delete( str_data )

    // Note(jnc) - The escape character for "{"" is 2 "{{", it will only show one char.
    return fmt.aprintf( "MA{{ type: %s, dims: %d, sizes: %s, data: %s }}", 
        a.type, a.dims, str_sizes, str_data )
}

// to_string() of a 2 D array.
//
// NOTE(jnc): If dims greater then 3,
//            then print only the first 2 dimensions/elements,
//            Then ...
//            Then the last dimention. 
//            Each dimension is also limited to the first 3 values and the last 2 values.
to_string_2d ::proc ( a : MA( $T ) ) -> string {
    trimer_row_i_index   : int : 3
    trimer_colum_j_index : int : 3
    str_data := strings.builder_make( len=0, cap=200 )
    defer strings.builder_destroy( &str_data )
    fmt.sbprintf( &str_data, "\n[" )
    for i in 0 ..< a.sizes[0] {
        i_to_print := []int{ 0, 1, 2, (a.sizes[ 0 ] - 1) }
        if slice.contains( i_to_print, i ) {
            if i == 0 {
                fmt.sbprintf( &str_data, " [" )
            } else {
                fmt.sbprintf( &str_data, "\n  [" )
            }
            for j in 0 ..< a.sizes[1] {
                j_to_print := []int{ 0, 1, 2, (a.sizes[ 1 ] - 1) }
                if slice.contains( j_to_print, j ) {                    
                    if j == 0 {
                        fmt.sbprintf( &str_data, " " )
                    } else {
                        fmt.sbprintf( &str_data, ", " )
                    }
                    // fmt.sbprintf( &str_data, "%v", a.data[ i * a.sizes[1] + j ] )
                    index := index_2d( i, j, a.sizes[1] )
                    fmt.sbprintf( &str_data, "%v", a.data[ index ] ) 
                } else if j == trimer_colum_j_index {
                    fmt.sbprintf( &str_data, ", ..." )
                }
            }
        } else if i == trimer_row_i_index {
            fmt.sbprintf( &str_data, "\n  ..." )
            continue;
        } else if i != (a.sizes[ 0 ] - 1) {  // In the intermediate lines don't close the brakets.
            continue;
        }
        fmt.sbprintf( &str_data, " ]")
    }
    fmt.sbprintf( &str_data, " ]")

    str_sizes := slice_to_string( a.sizes[:] )
    defer delete( str_sizes )

    res_str := fmt.aprintf( "MA{{ type: %v, dims: %d, sizes: %s, data: %s }}", 
                a.type, a.dims, str_sizes, strings.to_string( str_data ) )
    return res_str
}

// to_string() of a 3 D array.
//
// NOTE(jnc): If dims greater then 3,
//            then print only the first 2 dimensions/elements,
//            Then ...
//            Then the last dimention. 
//            Each dimension is also limited to the first 3 values and the last 2 values.
to_string_3d ::proc ( a : MA( $T ) ) -> string {
    
    trimer_row_i_index  : int : 3
    trimer_col_j_index  : int : 3
    trimer_deep_k_index : int : 3
    str_data := strings.builder_make( len=0, cap=600 )
    defer strings.builder_destroy( &str_data )
    
    fmt.sbprintf( &str_data, "\n[" )
    for i in 0 ..< a.sizes[0] {
        i_to_print := []int{ 0, 1, 2, (a.sizes[ 0 ] - 1) }
        if slice.contains( i_to_print, i ) {
            if i == 0 {
                fmt.sbprintf( &str_data, " [" )
            } else {
                fmt.sbprintf( &str_data, "\n\n  [" )
            }
            
        
            for j in 0 ..< a.sizes[1] {
                j_to_print := []int{ 0, 1, 2, (a.sizes[ 1 ] - 1) }
                if slice.contains( j_to_print, j ) {
                    if j == 0 {
                        fmt.sbprintf( &str_data, " [" )
                    } else {
                        fmt.sbprintf( &str_data, "\n    [" )
                    }
                    for k in 0 ..< a.sizes[2] {
                        k_to_print := []int{ 0, 1, 2, (a.sizes[ 2 ] - 1) }
                        if slice.contains( k_to_print, k ) {                    
                            if k == 0 {
                                fmt.sbprintf( &str_data, " " )
                            } else {
                                fmt.sbprintf( &str_data, ", " )
                            }
                            // fmt.sbprintf( &str_data, "%v", a.data[ h * a.sizes[1] + i * a.sizes[2] + j ] )
                            index := index_3d( i, j, k, a.sizes[1], a.sizes[2] ) 
                            fmt.sbprintf( &str_data, "%v", a.data[ index ] )
                        } else if k == trimer_deep_k_index {
                            fmt.sbprintf( &str_data, ", ..." )
                        }
                    }
                } else if j == trimer_col_j_index {
                    fmt.sbprintf( &str_data, "\n    ..." )
                    continue;
                } else if j != (a.sizes[ 1 ] - 1) {  // In the intermediate lines don't close the brakets.
                    continue;
                }
                fmt.sbprintf( &str_data, " ]")
            }
            fmt.sbprintf( &str_data, " ]")


        } else if i == trimer_row_i_index {
            fmt.sbprintf( &str_data, "\n\n  .........." )
            continue;
        } else if i != (a.sizes[ 0 ] - 1) {  // In the intermediate lines don't close the brakets.
            continue;
        }
    }
    fmt.sbprintf( &str_data, " ]")
    

    str_sizes := slice_to_string( a.sizes[:] )
    defer delete( str_sizes )

    res_str := fmt.aprintf( "MA{{ type: %v, dims: %d, sizes: %s, data: %s }}", 
                a.type, a.dims, str_sizes, strings.to_string( str_data ) )
    return res_str
}

// to_string() of a N Dimensional array.
to_string_nd ::proc ( a : MA( $T ) ) -> string {
    str_sizes := slice_to_string( a.sizes[:] )
    defer delete( str_sizes )

    return fmt.aprintf( "MA{{ type: %v, dims: %d, sizes: %s,\n data: %s }}", 
        a.type, a.dims, str_sizes, "Can't print a N Dimensional array!" )
}

// The function to_string( a ) that should be used.
to_string ::proc ( a : MA( $T ) ) -> string {
    if a.dims == 0 {
        return fmt.aprintf( "MA{{ type: %v, dims: %d, sizes: %s, data: %s }}", 
            a.type, a.dims, "nil", "nil" )
    }
    switch len(a.sizes) {
        case 1 : return to_string_1d( a );
        case 2 : return to_string_2d( a );
        case 3 : return to_string_3d( a );
        case : return to_string_nd( a );
    }
}

// Get the 1D linear position of a mapped 2D arrays.
// Odin like C is Raw major, so we also will be Raw major inside MArray.
index_2d :: #force_inline proc ( i, j, size_j : int ) -> int {
    return j + i * size_j
} 

// Get the 1D linear position of a mapped 3D arrays.
// Odin like C is Raw major, so we also will be Raw major inside MArray.
index_3d :: #force_inline proc ( i, j, k, size_j, size_k : int ) -> int {
    return k + j * size_k + i * size_j * size_k
} 

// Creates a Zero Matrix of the specified N Dimensions.
// A Zero Matrix has all element equal to zero.
zeros_a :: proc ( $T : typeid, sizes : []int ) -> MA( T ) {
    return create( T, sizes, 0 )
}

// Creates a One Matrix of the specified N Dimensions.
// A One Matrix has all element equal to zero.
ones_a :: proc ( $T : typeid, sizes : []int ) -> MA( T ) {
    return create( T, sizes, 1 )
}

// Generate a 1D MArray with the values of the given range and the increment.
arange_a :: proc (  $T : typeid, start : T, step : T, stop : T ) -> MA( T ) {

    // Test if the start and stop not equal
    if start == stop {
        panic( "Error in arange - The start parameter is equal to stop parameter." )
    }

    // Test if the step is valid
    if step == 0 {
        panic( "Error in arange - The step parameter can't be zero." )
    }

    // Test if the start and stop are valid
    if start < stop && step < 0  {
        panic( "Error in arange - The step parameter can't be negative if the start parameter is less then the stop parameter." )
    } else if start > stop && step > 0 {
        panic( "Error in arange - The step parameter can't be positive if the start parameter is greater then the stop parameter." )
    }

    // Determine the min and the max values of the range.
    min : T
    max : T
    if start < stop {
        min = start
        max = stop
    } else {
        min = stop
        max = start
    }

    // Determine the number of elements in the range.
    num_elements : int = int( ( max - min ) / math.abs( step ) )
    
    if num_elements == 0 {
        panic( "Error in arange - The number of elements in the range is zero" )
    }
    
    res := MA( T ) {
        type  = create_emt( T ),
        dims  = 1,
        sizes = make( [dynamic]int, 0, num_elements ),
        data  = make( [dynamic]T, len=0, cap=num_elements ),
    }

    // Copy the 1D size to the dynamic array a.sizes.
    append( &res.sizes, num_elements + 1 )

    for i in 0 ..= num_elements {
        val := min + T( i ) * step
        append( &res.data, val )
    }

    return res
}

/*
ex:

b = MA.arange( 0.0, 0.1, 10.0 )

*/

// Tests if coordenates is inbound and generates a error if it is not.
// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
is_coord_inbound :: #force_inline proc ( a : MA( $T ), dim : int, index : int ) ->
                        (res_index : int, error : bool, error_str : string ) {
    index := index
    ind_len := a.sizes[ dim ]
    if index < 0 && index >= -ind_len {
        index = ind_len + index
    } else if index < 0 || index >= ind_len {
        str_dims := ""
        switch dim {
            case 0 /* 'i' */ : str_dims = "i";
            case 1 /* 'j' */ : str_dims = "_, j";
            case 2 /* 'k' */ : str_dims = "_, _, k";
        }
        str_tmp := fmt.aprintf( "Index out of bounds %s coordenate, [ %v ] 0 <= a < %v.",
                                str_dims, index, ind_len )
        return index, true, str_tmp;
    }
    return index, false, ""
}

// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
get_1d :: #force_inline proc ( a : MA( $T ), ind_i : int ) -> T {
    // TODO(jnc) : Test if in the context (Odin), if there it is supose to validate the index is inbound.

    ind_i__, error, error_msg := is_coord_inbound( a, 0, ind_i )
    if error {
        panic( error_msg )
    }

    return a.data[ ind_i__ ]
}

// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
get_2d :: #force_inline proc ( a : MA( $T ), ind_i, ind_j : int ) -> T {
    // TODO(jnc) : Test if in the context (Odin), if there it is supose to validate the index is inbound.

    ind_i__, error_i, error_i_msg := is_coord_inbound( a, 0, ind_i )
    if error_i {
        panic( error_i_msg )
    }
    ind_j__, error_j, error_j_msg := is_coord_inbound( a, 1, ind_j )
    if error_j {
        panic( error_j_msg )
    }

    index := index_2d( ind_i__, ind_j__, a.sizes[1] )
    return a.data[ index ]
}

// Supports negative indexes, that are mapped from the end of the vector "val = get(a, 3, -1)"
get_3d :: #force_inline proc ( a : MA( $T ), ind_i, ind_j, ind_k : int ) -> T {
    // TODO(jnc) : Test if in the context (Odin), if there it is supose to validate the index is inbound.

    ind_i__, error_i, error_i_msg := is_coord_inbound( a, 0, ind_i )
    if error_i {
        panic( error_i_msg )
    }
    ind_j__, error_j, error_j_msg := is_coord_inbound( a, 1, ind_j )
    if error_j {
        panic( error_j_msg )
    }
    ind_k__, error_k, error_k_msg  := is_coord_inbound( a, 2, ind_k )
    if error_k {
        panic( error_k_msg )
    }

    index := index_3d( ind_i__, ind_j__, ind_k__, a.sizes[1], a.sizes[2] )
    return a.data[ index ]
}

get :: proc { get_1d, get_2d, get_3d }

// get( a : MA< T >, ind_i, ind_j, ind_k, int_a : int, ... ) -> T   // Variable num arguments

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


// Supports negative indexes, that are mapped from the end of the vector "set(a, 3, -1)"
set_m_1d :: #force_inline proc ( a : MA( $T ), value : T, ind_i : int ) {
    ind_i__, error_i, error_i_msg := is_coord_inbound( a, 0, ind_i )
    if error_i {
        panic( error_i_msg )
    }
    a.data[ ind_i__ ] = value
}

// Supports negative indexes, that are mapped from the end of the vector "set(a, 3, -1)"
set_m_2d :: #force_inline proc ( a : MA( $T ), value: T, ind_i, ind_j : int ) {
    ind_i__, error_i, error_i_msg := is_coord_inbound( a, 0, ind_i )
    if error_i {
        panic( error_i_msg )
    }
    ind_j__, error_j, error_j_msg := is_coord_inbound( a, 1, ind_j )
    if error_j {
        panic( error_j_msg )
    }
    index := index_2d( ind_i__, ind_j__, a.sizes[1] )
    a.data[ index ] = value
}

// Supports negative indexes, that are mapped from the end of the vector "set(a, 3, -1)"
set_m_3d :: #force_inline proc ( a : MA( $T ), value: T, ind_i, ind_j, ind_k : int ) {
    ind_i__, error_i, error_i_msg := is_coord_inbound( a, 0, ind_i )
    if error_i {
        panic( error_i_msg )
    }
    ind_j__, error_j, error_j_msg := is_coord_inbound( a, 1, ind_j )
    if error_j {
        panic( error_j_msg )
    }
    ind_k__, error_k, error_k_msg := is_coord_inbound( a, 2, ind_k )
    if error_k {
        panic( error_k_msg )
    }
    index := index_3d( ind_i__, ind_j__, ind_k__, a.sizes[1], a.sizes[2] )
    a.data[ index ] = value
}

set_m :: proc { set_m_1d, set_m_2d, set_m_3d }

// set_m() 4 D and more variable num arguments
// set_m :: #force_inline proc ( a : MA( $T ), value: T, ind_i, ind_j, ind_k, int a : int, ...  ) -> T 


/* 

// Allocates
// RANGE
set( a : MA< T >, val : T, a : []Range )

*/

// Allocates
copy_a :: proc ( a : MA( $T ) ) -> MA( T ) {
    return MA( T ) {
        type  = a.type,
        dims  = a.dims,
        sizes = slice.clone_to_dynamic( a.sizes[:] ),
        data  = slice.clone_to_dynamic( a.data[:] ),
    }
} 

// Change the shape of the matrix, mantaining all elements and it's number.
// Doesn't change the data elements.
reshape_m :: proc ( a : ^MA( $T ), new_sizes : []int ) {
   
    calc_size :: proc ( sizes : []int ) -> int {
        mul_dim_len : int = 1
        for i in sizes {
            if i <= 0 {
                panic( "Error in reshape - Zero or negative size in coordenate." )
            }
            mul_dim_len *= i
        }
        return mul_dim_len
    }

    if  len( new_sizes ) == 1 && new_sizes[0] == -1 {
        new_sizes[0] = calc_size( a.sizes[:] )
    }

    // Test if the new coordiante sizes are valid.
    if calc_size( new_sizes ) != calc_size( a.sizes[:] ) {
        panic( "Error in reshape - Invalid new_size parameter. The number of elements in the array is different from the number of elements multiply of all the sizes array in the parameter new_array." )
    }

    a.dims = len( new_sizes )
    a.sizes = slice.clone_to_dynamic( new_sizes )
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


/*

Iterating on the elements of an array:

/*

Iterate on the elements of the following 1-D array:
import numpy as np

arr = np.array([1, 2, 3])

for x in arr:
  print(x) 

*/


/*

Iterate on the elements of the following 2-D array:
import numpy as np

arr = np.array([[1, 2, 3], [4, 5, 6]])

for x in arr:
  print(x) 

*/


/*

Iterate down to the scalars:
import numpy as np

arr = np.array([[[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [10, 11, 12]]])

for x in arr:
  for y in x:
    for z in y:
      print(z) 

*/


*/

// ############################################################################
// ############################################################################
// ############################################################################

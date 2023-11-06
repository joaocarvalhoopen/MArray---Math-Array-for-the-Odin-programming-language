package marray

// import "core.strings"
import "core:intrinsics"
import "core:slice"
import "core:math"
import "core:math/bits"
import "core:mem"
import "core:fmt"
import "core:runtime"


// Method convention legend:
// pxxx( c )         <- Point operation, operation on each element of the matrix,
//                      equivalent to Julia's ".+", ".-", ".*" operations.
// xxxx_a( c )       <- Allocates array MA< T >
// xxxx_m( a, b )    <- Mutates a parameter array and returns a parameter array MA< T >
// xxxx_t( t, a, b ) <- Makes the operation and writes into parameter t and
//                      returns parameter t array MA< T >


// point apply mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
papply_m :: proc ( a : ^MA( $T ), b: MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := psum_t( a, a^, b )
    return b
}

// point apply into "t target", "a" and parameter "b",
// returning "t".
papply_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = func( a.data[ i ], b.data[ i ] )
    }
    return t^
}

// ############################################################################
// ############################################################################

// point sum mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
psum_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := psum_t( a, a^, b )
    return b

    // for i in 0 ..< len( a.data ) {
    //     a^.data[ i ] += b.data[ i ]
    // }
    // return b
}

// point sum into "t target", "a" and parameter "b",
// returning "t".
psum_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] + b.data[ i ]
    }
    return t^
}

// point sub mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
psub_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := psub_t( a, a^, b )
    return b
}

// point sub into "t target", "a" and parameter "b",
// returning "t".
psub_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] - b.data[ i ]
    }
    return t^
}

// point mul mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
pmul_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := pmul_t( a, a^, b )
    return b
}

// point mul into "t target", "a" and parameter "b",
// returning "t".
pmul_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] * b.data[ i ]
    }
    return t^
}

// point div mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
pdiv_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := pdiv_t( a, a^, b )
    return b
}

// point div into "t target", "a" and parameter "b",
// returning "t".
pdiv_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] / b.data[ i ]
    }
    return t^
}

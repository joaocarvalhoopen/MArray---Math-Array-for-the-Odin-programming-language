package marray

// import "core.strings"
import "core:intrinsics"
import "core:slice"
import "core:math"
import "core:math/bits"
import "core:mem"
import "core:fmt"
import "core:runtime"


// apply mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
apply_m :: proc ( a : ^MA( $T ), b: MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := sum_t( a, a^, b )
    return b
}

// apply into "t target", "a" and parameter "b",
// returning "t".
apply_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ), func : proc ( a : T, b: T ) -> T ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = func( a.data[ i ], b.data[ i ] )
    }
    return t^
}

// ############################################################################
// ############################################################################

// sum mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
sum_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := sum_t( a, a^, b )
    return b

    // for i in 0 ..< len( a.data ) {
    //     a^.data[ i ] += b.data[ i ]
    // }
    // return b
}

// sum into "t target", "a" and parameter "b",
// returning "t".
sum_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] + b.data[ i ]
    }
    return t^
}

// sub mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
sub_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := sub_t( a, a^, b )
    return b
}

// sub into "t target", "a" and parameter "b",
// returning "t".
sub_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] - b.data[ i ]
    }
    return t^
}

// mul mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
mul_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := mul_t( a, a^, b )
    return b
}

// mul into "t target", "a" and parameter "b",
// returning "t".
mul_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] * b.data[ i ]
    }
    return t^
}

// div mutable that sums the a with the b parameter
// and puts the result into parameter "a",
// return "a".
div_m :: proc ( a : ^MA( $T ), b: MA( T ) ) -> MA( T ) 
where intrinsics.type_is_numeric( T ) {
    b := div_t( a, a^, b )
    return b
}

// div into "t target", "a" and parameter "b",
// returning "t".
div_t :: proc ( t : ^MA( $T ), a : MA( T ), b : MA( T ) ) -> MA( T )
where intrinsics.type_is_numeric( T ) {
    for i in 0 ..< len( a.data ) {
        t^.data[ i ] = a.data[ i ] / b.data[ i ]
    }
    return t^
}

package marray_main

import ma "./marray"
import "core:fmt"

MA :: ma.MA

// Method convention legend:
// pxxxx( c )         <- Point operation, operation on each element of the matrix,
//                      equivalent to Julia's ".+", ".-", ".*" operations.
// xxxx_a( c )       <- Allocates array MA< T >
// xxxx_m( a, b )    <- Mutates a parameter array and returns a parameter array MA< T >
// xxxx_t( t, a, b ) <- Makes the operation and writes into parameter t and
//                      returns parameter t array MA< T >

main :: proc () {
  
    a : MA( f32 ) = ma.create( f32, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    fmt.println( a )

    b := ma.create( f32, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )
    fmt.println( b )


    c := ma.psum_m( & a, b )
    fmt.println( c )


    correct_value: f32 = 2.5 + 1.5

    d := ma.create( f32, []int{ 2, 3 }, correct_value )
    defer ma.del( & d )

    fmt.println( "equals( c, d ): %s", ma.equal( c, d ) )



    e := ma.create( f32, []int{ 3 }, 1.0 )
    defer ma.del( & e )

    str_tmp_1 := ma.to_string_1d( e )
    defer delete( str_tmp_1 )
    
    fmt.println( "ma.to_string_1d( e ) : ", str_tmp_1 )


    f := ma.create( f32, []int{ 4, 4 }, 2.0 )
    defer ma.del( & f )
    
    str_tmp_3 := ma.to_string_2d( f )
    defer delete( str_tmp_3 )
    fmt.println("ma.to_string_2d( f ) : ", str_tmp_3 )


    g := ma.create( f32, []int{ 5, 5 }, 2.0 )
    defer ma.del( & g )
    
    str_tmp_4 := ma.to_string_2d( g )
    defer delete( str_tmp_4 )
    fmt.println("ma.to_string_2d( g ) : ", str_tmp_4 )


    h := ma.create( f32, []int{ 5, 5, 5 }, 3.0 )
    defer ma.del( & h )
    
    str_tmp_5 := ma.to_string_3d( h )
    defer delete( str_tmp_5 )
    fmt.println("ma.to_string_3d( h ) : ", str_tmp_5 )
} 


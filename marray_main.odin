package marray_main

import ma "./marray"
import "core:fmt"

MA :: ma.MA

main :: proc () {
  
    a : MA( f32 ) = ma.create( f32, []int{ 2, 3 }, 2.5 )
    defer ma.del( & a )
    fmt.println( a )

    b := ma.create( f32, []int{ 2, 3 }, 1.5 )
    defer ma.del( & b )
    fmt.println( b )


    c := ma.sum_m( & a, b )
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


/*

main :: proc () {
  
    a : MA( f32 ) = ma.create( f32, []int{ 2, 3 }, 2.5 )
    defer ma.del( a )
    fmt.println( a )

    b := ma.create( f32, []int{ 2, 3 }, 1.5 )
    defer ma.del( b )
    fmt.println( b )


    c := ma.sum_m( a, b )
    fmt.println( c )


    correct_value: f32 = 2.5 + 1.5

    d := ma.create( f32, []int{ 2, 3 }, correct_value )
    defer ma.del( d )

    fmt.println( "equals( c, d ): %s", ma.equal( c, d ) )



    e := ma.create( f32, []int{ 3 }, 1.0 )
    defer ma.del( e )

    str_tmp_1 := ma.to_string_1d( e )
    defer delete( str_tmp_1 )
    
    fmt.println( "ma.to_string_1d( e ) : ", str_tmp_1 )


    f := ma.create( f32, []int{ 4, 4 }, 2.0 )
    defer ma.del( f )
    
    str_tmp_3 := ma.to_string_2d( f )
    defer delete( str_tmp_3 )
    fmt.println("ma.to_string_2d( f ) : ", str_tmp_3 )


    g := ma.create( f32, []int{ 5, 5 }, 2.0 )
    defer ma.del( g )
    
    str_tmp_4 := ma.to_string_2d( g )
    defer delete( str_tmp_4 )
    fmt.println("ma.to_string_2d( g ) : ", str_tmp_4 )


    h := ma.create( f32, []int{ 5, 5, 5 }, 3.0 )
    defer ma.del( h )
    
    str_tmp_5 := ma.to_string_3d( h )
    defer delete( str_tmp_5 )
    fmt.println("ma.to_string_3d( h ) : ", str_tmp_5 )


} 

*/
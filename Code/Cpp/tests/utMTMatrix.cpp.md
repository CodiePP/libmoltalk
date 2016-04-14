Copyright 2016 by Alexander Diemand

[LICENSE](../../LICENSE)

~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"
#include "boost/chrono.hpp"
#include "boost/chrono/chrono_io.hpp"
#include "boost/chrono/round.hpp"


#include "MTMatrix.hpp"
#include "MTMatrix53.hpp"
#include <cmath>
#include <iostream>
~~~

# Test suite: utMTMatrix
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTMatrix )
~~~

## Test case: test_ctor
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_ctor )
{
    mt::MTMatrix _m(4,4);
    BOOST_CHECK_EQUAL( _m.atRowCol(0,0), 0.0 );
    BOOST_CHECK_EQUAL( _m.atRowCol(0,2), 0.0 );
    BOOST_CHECK_EQUAL( _m.rows(), 4 );
    BOOST_CHECK_EQUAL( _m.cols(), 4 );
}
~~~

## Test case: test_transposed
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_transposed )
{
    mt::MTMatrix _m(3,4);
    BOOST_CHECK( !_m.isTransposed() );
    BOOST_CHECK_EQUAL( _m.rows(), 3 );
    BOOST_CHECK_EQUAL( _m.cols(), 4 );
    _m.transpose();
    BOOST_CHECK( _m.isTransposed() );
    BOOST_CHECK_EQUAL( _m.rows(), 4 );
    BOOST_CHECK_EQUAL( _m.cols(), 3 );
}
~~~

## Test case: test_toString
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_toString )
{
    mt::MTMatrix _m(3,4);
    for (int r=0; r<3; r++) {
        for (int c=0; c<4; c++) {
            _m.atRowColValue(r,c, 1.17*r*c); }}
    auto s = _m.toString();
    BOOST_CHECK_EQUAL( "[[0.00000,0.00000,0.00000,0.00000][0.00000,1.17000,2.34000,3.51000][0.00000,2.34000,4.68000,7.02000]]", s );
}
~~~

## Test case: test_matrixOfColumn
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_matrixOfColumn )
{
    mt::MTMatrix _m(3,4);
    for (int r=0; r<3; r++) {
        for (int c=0; c<4; c++) {
            _m.atRowColValue(r,c, 1.17*r*c); }}
    BOOST_CHECK_EQUAL( "[[0.00000][0.00000][0.00000]]", _m.matrixOfColumn(0).toString() );
    BOOST_CHECK_EQUAL( "[[0.00000][1.17000][2.34000]]", _m.matrixOfColumn(1).toString() );
    BOOST_CHECK_EQUAL( "[[0.00000][2.34000][4.68000]]", _m.matrixOfColumn(2).toString() );
    BOOST_CHECK_EQUAL( "[[0.00000][3.51000][7.02000]]", _m.matrixOfColumn(3).toString() );
}
~~~

## Test case: test_x
matrix multiplication
```
 [ -1, 11.0, 0.0       [ 1, 1      [ -1+11, -1+11
   3.2, 1,   1   ]  x    1, 1    =   3.2+1+1, 3.2+1+1 ]
                         1, 1 ]
```

~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_x )
{
    mt::MTMatrix m1(2,3);
    mt::MTMatrix m2(3,2);
    m1.atRowColValue(0,0, -1.0);
    m1.atRowColValue(1,0,  3.2);
    m1.atRowColValue(0,1, 11.0);
    m1.atRowColValue(1,1,  1.0);
    m1.atRowColValue(1,2,  1.0);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m2.atRowColValue(r,c,  1.0); }}
    auto m3 = m1.x(m2);
    auto s = m3.toString();
    BOOST_CHECK_EQUAL( "[[10.00000,10.00000][5.20000,5.20000]]", s );
}
~~~

## Test case: test_mmultiply
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_mmultiply )
{
    mt::MTMatrix m1(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m1.atRowColValue(r,c,  -1.0); }}
    mt::MTMatrix m2(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m2.atRowColValue(r,c,  2.0); }}
    auto m3 = m1.mmultiply(m2);
    BOOST_CHECK_EQUAL( -2.0, m3.atRowCol(0,0) );
    BOOST_CHECK_EQUAL( -2.0, m3.atRowCol(0,1) );
    BOOST_CHECK_EQUAL( -2.0, m3.atRowCol(1,0) );
    BOOST_CHECK_EQUAL( -2.0, m3.atRowCol(1,1) );
    BOOST_CHECK_EQUAL( -2.0, m3.atRowCol(2,0) );
    BOOST_CHECK_EQUAL( -2.0, m3.atRowCol(2,1) );
}
~~~

## Test case: test_msubtract
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_msubtract )
{
    mt::MTMatrix m1(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m1.atRowColValue(r,c,  1.0); }}
    mt::MTMatrix m2(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m2.atRowColValue(r,c,  2.0); }}
    auto m3 = m1.msubtract(m2);
    BOOST_CHECK_EQUAL( -1.0, m3.atRowCol(0,0) );
    BOOST_CHECK_EQUAL( -1.0, m3.atRowCol(0,1) );
    BOOST_CHECK_EQUAL( -1.0, m3.atRowCol(1,0) );
    BOOST_CHECK_EQUAL( -1.0, m3.atRowCol(1,1) );
    BOOST_CHECK_EQUAL( -1.0, m3.atRowCol(2,0) );
    BOOST_CHECK_EQUAL( -1.0, m3.atRowCol(2,1) );
}
~~~

## Test case: test_madd
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_madd )
{
    mt::MTMatrix m1(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m1.atRowColValue(r,c,  -1.0); }}
    mt::MTMatrix m2(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m2.atRowColValue(r,c,  2.0); }}
    auto m3 = m1.madd(m2);
    BOOST_CHECK_EQUAL( 1.0, m3.atRowCol(0,0) );
    BOOST_CHECK_EQUAL( 1.0, m3.atRowCol(0,1) );
    BOOST_CHECK_EQUAL( 1.0, m3.atRowCol(1,0) );
    BOOST_CHECK_EQUAL( 1.0, m3.atRowCol(1,1) );
    BOOST_CHECK_EQUAL( 1.0, m3.atRowCol(2,0) );
    BOOST_CHECK_EQUAL( 1.0, m3.atRowCol(2,1) );
}
~~~

## Test case: test_addScalar
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_addScalar )
{
    mt::MTMatrix m1(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m1.atRowColValue(r,c,  -1.0); }}
    m1.addScalar(1.0);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            BOOST_CHECK_EQUAL( 0.0, m1.atRowCol(r,c) ); }}
}
~~~

## Test case: test_multiplyByScalar
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_multiplyByScalar )
{
    mt::MTMatrix m1(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m1.atRowColValue(r,c,  -1.0); }}
    m1.multiplyByScalar(-1.0);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            BOOST_CHECK_EQUAL( 1.0, m1.atRowCol(r,c) ); }}
}
~~~

## Test case: test_divideByScalar
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_divideByScalar )
{
    mt::MTMatrix m1(3,2);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            m1.atRowColValue(r,c,  8.0); }}
    m1.divideByScalar(2.0);
    m1.divideByScalar(2.0);
    m1.divideByScalar(2.0);
    for (int r=0; r<3; r++) {
        for (int c=0; c<2; c++) {
            BOOST_CHECK_EQUAL( 1.0, m1.atRowCol(r,c) ); }}
}
~~~

## Test case: test_diagonalizeWithMaxError
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_diagonalizeWithMaxError )
{
    mt::MTMatrix m1(3,3);
    for (int r=0; r<3; r++) {
        for (int c=0; c<3; c++) {
            m1.atRowColValue(r,c,  r*2.0-c+0.5); }}
    auto m2 = m1.diagonalizeWithMaxError(0.001);
    auto s = m2.toString();
    BOOST_CHECK_EQUAL( "[[-1.04846,8.68008,-3.13161][0.39761,0.52873,-0.74990][-0.85330,0.51353,-0.09036][0.33732,0.67582,0.65535]]", s );
}
~~~

## Test case: test_jacobianDiagonalizeWithMaxError
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_jacobianDiagonalizeWithMaxError )
{
    mt::MTMatrix m1(3,3);
    for (int r=0; r<3; r++) {
        for (int c=0; c<3; c++) {
            m1.atRowColValue(r,c,  r*2.0-c+0.5); }}
    auto m2 = m1.jacobianDiagonalizeWithMaxError(0.001);
    auto s = m2.toString();
    BOOST_CHECK_EQUAL( "[[-1.04846,8.68008,-3.13161][0.39761,0.52873,-0.74990][-0.85330,0.51353,-0.09036][0.33732,0.67582,0.65535]]", s );
}
~~~

## Test case: test_com
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_com )
{
    mt::MTMatrix m1(3,3);
    for (int r=0; r<3; r++) {
        for (int c=0; c<3; c++) {
            m1.atRowColValue(r,c,  r*2.0-c+0.5); }}
    std::clog << m1 << std::endl;
    auto m2 = m1.centerOfMass();
    auto s = m2.toString();
    BOOST_CHECK_EQUAL( "[[2.50000,1.50000,0.50000]]", s );
}
~~~

## Test case: test_sum
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_sum )
{
    mt::MTMatrix m1(3,3);
    for (int r=0; r<3; r++) {
        for (int c=0; c<3; c++) {
            m1.atRowColValue(r,c,  r*2.0-c+0.5); }}
    BOOST_CHECK_EQUAL( 13.50, m1.sum() );
}
~~~

## Test case: test_square
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_square )
{
    mt::MTMatrix m1(3,3);
    for (int r=0; r<3; r++) {
        for (int c=0; c<3; c++) {
            m1.atRowColValue(r,c,  r*2.0-c+0.5); }}
    m1.square();
    BOOST_CHECK_EQUAL( 50.25, m1.sum() );
}
~~~

## Test case: test_atRowColAdd
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_atRowColAdd )
{
    mt::MTMatrix m(2,2);
    m.atRowColAdd(0,1, 3.5);
    BOOST_CHECK_EQUAL( 0.0, m.atRowCol(0,0) );
    BOOST_CHECK_EQUAL( 3.5, m.atRowCol(0,1) );
}
~~~

## Test case: test_atRowColMult
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_atRowColMult )
{
    mt::MTMatrix m(2,2);
    m.atRowColValue(1,1, 1.0);
    m.atRowColMult(1,1, -2.0);
    BOOST_CHECK_EQUAL( 0.0, m.atRowCol(0,0) );
    BOOST_CHECK_EQUAL( -2.0, m.atRowCol(1,1) );
}
~~~

## Test case: test_alignTo
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_alignTo )
{
    auto fn = []()-> mt::MTMatrix53 {
        mt::MTMatrix m1(4,3);
        mt::MTMatrix m2(4,3);
        m1.atRowColValue(0,0, 1.0);
        m1.atRowColValue(0,1, -1.0);
        m1.atRowColValue(0,2, -1.0);
        m1.atRowColValue(1,0, 2.0);
        m1.atRowColValue(1,1, 1.0);
        m1.atRowColValue(1,2, 1.2);
        m1.atRowColValue(2,0, 3.0);
        m1.atRowColValue(2,1, 2.0);
        m1.atRowColValue(2,2, 2.2);
        m1.atRowColValue(3,0, 4.0);
        m1.atRowColValue(3,1, 3.0);
        m1.atRowColValue(3,2, 3.2);
        m2.atRowColValue(0,0, 1.1);
        m2.atRowColValue(0,1, -1.1);
        m2.atRowColValue(0,2, -1.1);
        m2.atRowColValue(1,0, 2.1);
        m2.atRowColValue(1,1, 1.2);
        m2.atRowColValue(1,2, 1.3);
        m2.atRowColValue(2,0, 3.1);
        m2.atRowColValue(2,1, 2.2);
        m2.atRowColValue(2,2, 2.3);
        m2.atRowColValue(3,0, 4.1);
        m2.atRowColValue(3,1, 3.2);
        m2.atRowColValue(3,2, 3.4);
        return m1.alignTo(m2); };

    const int n = 10000;
    auto t0 = boost::chrono::system_clock::now();
    for (int i = 0; i < n; i++) {
        mt::MTMatrix53 mtr = fn(); }
    auto t1 = boost::chrono::system_clock::now();
    auto tdiff = t1 - t0;
    long ms = boost::chrono::duration_cast\<boost::chrono::milliseconds\>(tdiff).count();
    long us = boost::chrono::duration_cast\<boost::chrono::microseconds\>(tdiff / n).count();
    std::clog << "it took " << ms << " milliseconds" << std::endl;
    std::clog << "it took " << us << " microseconds per iteration" << std::endl;
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

Copyright 2016 by Alexander Diemand

[LICENSE](../../LICENSE)

~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"

#include "MTMatrix53.hpp"
#include "MTCoordinates.hpp"

#include <cmath>
#include <iostream>
~~~

# Test suite: utMTMatrix53
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTMatrix53 )
~~~

## Test case: test_ctor
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_ctor )
{
    mt::MTMatrix53 m;
    BOOST_CHECK_EQUAL( m.atRowCol(0,0), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(1,1), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(2,2), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(3,1), 0.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(4,0), 0.0 );
    BOOST_CHECK_EQUAL( m.rows(), 5 );
    BOOST_CHECK_EQUAL( m.cols(), 3 );
}
~~~

## Test case: test_invert
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_invert )
{
    mt::MTMatrix53 m;
    m.atRowColValue(1,0, -1.0 );
    m.atRowColValue(0,1, 1.0 );
    m.atRowColValue(1,2, 1.0 );
    m.atRowColValue(2,1, -1.0 );

    m.atRowColValue(3,0, -1.0 );
    m.atRowColValue(3,1, 1.0 );
    m.atRowColValue(3,2, -1.0 );
    m.atRowColValue(4,0, 2.0 );
    m.atRowColValue(4,1, 2.0 );
    m.atRowColValue(4,2, 2.0 );
    m.invert();
    BOOST_CHECK_EQUAL( m.atRowCol(0,0), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(1,1), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(2,2), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(3,1), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(4,0), 2.0 );
    BOOST_CHECK_EQUAL( "[[1.00000,1.00000,0.00000][-1.00000,1.00000,1.00000][0.00000,-1.00000,1.00000][-1.00000,1.00000,-1.00000][2.00000,2.00000,2.00000]]", m.toString() );
}
~~~

## Test case: test_getRotation
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_getRotation )
{
    mt::MTMatrix53 m;
    m.atRowColValue(3,0, -1.0 );
    m.atRowColValue(3,1, 1.0 );
    m.atRowColValue(3,2, -1.0 );
    m.atRowColValue(4,0, 2.0 );
    m.atRowColValue(4,1, 2.0 );
    m.atRowColValue(4,2, 2.0 );
    auto r = m.getRotation();
    BOOST_CHECK_EQUAL( r.atRowCol(0,0), 1.0 );
    BOOST_CHECK_EQUAL( r.atRowCol(1,1), 1.0 );
    BOOST_CHECK_EQUAL( r.atRowCol(2,2), 1.0 );
    BOOST_CHECK_EQUAL( r.atRowCol(3,3), 1.0 );
    BOOST_CHECK_EQUAL( 4.0, r.sum() );
}
~~~

## Test case: test_getTranslation
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_getTranslation )
{
    mt::MTMatrix53 m;
    m.atRowColValue(3,0, -1.0 );
    m.atRowColValue(3,1, 1.0 );
    m.atRowColValue(3,2, -1.0 );
    m.atRowColValue(4,0, 2.0 );
    m.atRowColValue(4,1, 2.0 );
    m.atRowColValue(4,2, 2.0 );
    auto t = m.getTranslation();
    BOOST_CHECK_EQUAL( t.atRowCol(0,0), 1.0 );
    BOOST_CHECK_EQUAL( t.atRowCol(1,1), 1.0 );
    BOOST_CHECK_EQUAL( t.atRowCol(2,2), 1.0 );
    BOOST_CHECK_EQUAL( t.atRowCol(3,3), 1.0 );
    BOOST_CHECK_EQUAL( t.atRowCol(3,0), 2.0 );
    BOOST_CHECK_EQUAL( t.atRowCol(3,1), 2.0 );
    BOOST_CHECK_EQUAL( t.atRowCol(3,2), 2.0 );
}
~~~

## Test case: test_getOrigin
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_getOrigin )
{
    mt::MTMatrix53 m;
    m.atRowColValue(3,0, -1.0 );
    m.atRowColValue(3,1, 1.0 );
    m.atRowColValue(3,2, -1.0 );
    m.atRowColValue(4,0, 2.0 );
    m.atRowColValue(4,1, 2.0 );
    m.atRowColValue(4,2, 2.0 );
    auto o = m.getOrigin();
    BOOST_CHECK_EQUAL( o.atDim(0), -1.0 );
    BOOST_CHECK_EQUAL( o.atDim(1), 1.0 );
    BOOST_CHECK_EQUAL( o.atDim(2), -1.0 );
}
~~~

## Test case: test_transformation3By3
TODO  :exclamation:
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_transformation3By3 )
{
}
~~~

## Test case: test_withRotation
TODO  :exclamation:
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_withRotation )
{
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

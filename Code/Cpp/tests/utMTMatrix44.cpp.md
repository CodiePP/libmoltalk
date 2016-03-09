
~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"

#include "MTMatrix44.hpp"
#include "MTCoordinates.hpp"

#include <cmath>
#include <iostream>
~~~

# Test suite: utMTMatrix44
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTMatrix44 )
~~~

## Test case: test_ctor
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_ctor )
{
    mt::MTMatrix44 m;
    BOOST_CHECK_EQUAL( m.atRowCol(0,0), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(1,1), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(2,2), 1.0 );
    BOOST_CHECK_EQUAL( m.atRowCol(3,3), 1.0 );
    BOOST_CHECK_EQUAL( m.sum(), 4.0 );
    BOOST_CHECK_EQUAL( m.rows(), 4 );
    BOOST_CHECK_EQUAL( m.cols(), 4 );
    BOOST_CHECK_EQUAL( "[[1.00000,0.00000,0.00000,0.00000][0.00000,1.00000,0.00000,0.00000][0.00000,0.00000,1.00000,0.00000][0.00000,0.00000,0.00000,1.00000]]", m.toString() );
}
~~~

## Test case: test_invert
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_invert )
{
    mt::MTMatrix44 m;
    m.atRowColValue(1,0, -2.0);
    m.atRowColValue(0,1, 2.0);
    m.atRowColValue(3,0, 1.0);  // tr_x
    m.atRowColValue(3,1, -1.0); // tr_y
    m.atRowColValue(3,2, 1.0);  // tr_z
    BOOST_CHECK_EQUAL( "[[1.00000,2.00000,0.00000,0.00000][-2.00000,1.00000,0.00000,0.00000][0.00000,0.00000,1.00000,0.00000][1.00000,-1.00000,1.00000,1.00000]]", m.toString() );
    m.invert();
    BOOST_CHECK_EQUAL( "[[1.00000,-2.00000,0.00000,0.00000][2.00000,1.00000,0.00000,0.00000][0.00000,0.00000,1.00000,0.00000][-1.00000,1.00000,-1.00000,1.00000]]", m.toString() );
}
~~~

## Test case: test_chainWith
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_chainWith )
{
    mt::MTMatrix44 m1;
    mt::MTMatrix44 m2;
    m1.chainWith(m2); // neutral
    BOOST_CHECK_EQUAL( "[[1.00000,0.00000,0.00000,0.00000][0.00000,1.00000,0.00000,0.00000][0.00000,0.00000,1.00000,0.00000][0.00000,0.00000,0.00000,1.00000]]", m1.toString() );
    m1.atRowColValue(0,1, 2.0);
    m1.atRowColValue(1,0, 2.0);
    m1.atRowColValue(3,0, 1.0);
    m1.atRowColValue(3,1, -1.0);
    m1.atRowColValue(3,2, 1.0);
    m2.chainWith(m1); // stretch
    BOOST_CHECK_EQUAL( "[[1.00000,2.00000,0.00000,0.00000][2.00000,1.00000,0.00000,0.00000][0.00000,0.00000,1.00000,0.00000][1.00000,-1.00000,1.00000,1.00000]]", m2.toString() );
}
~~~

## Test case: test_xIP
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_xIP )
{
    mt::MTMatrix44 m1;
    mt::MTMatrix44 m2;
    m1.atRowColValue(0,1, -2.0);
    m1.atRowColValue(1,0, 2.0);
    m2.atRowColValue(3,1, -1.0);
    m2.atRowColValue(3,2, -2.0);
    m1.xIP(m2);
    BOOST_CHECK_EQUAL( "[[1.00000,-2.00000,0.00000,0.00000][2.00000,1.00000,0.00000,0.00000][0.00000,0.00000,1.00000,0.00000][0.00000,-1.00000,-2.00000,1.00000]]", m1.toString() );
}
~~~

## Test case: test_rotationX
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_rotationX )
{
    auto m = mt::MTMatrix44::rotationX(15.0);
    BOOST_CHECK_EQUAL( "[[1.00000,0.00000,0.00000,0.00000][0.00000,0.96593,0.25882,0.00000][0.00000,-0.25882,0.96593,0.00000][0.00000,0.00000,0.00000,1.00000]]", m.toString() );
}
~~~

## Test case: test_rotationY
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_rotationY )
{
    auto m = mt::MTMatrix44::rotationY(-15.0);
    BOOST_CHECK_EQUAL( "[[0.96593,0.00000,0.25882,0.00000][0.00000,1.00000,0.00000,0.00000][-0.25882,0.00000,0.96593,0.00000][0.00000,0.00000,0.00000,1.00000]]", m.toString() );
}
~~~

## Test case: test_rotationZ
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_rotationZ )
{
    auto m = mt::MTMatrix44::rotationZ(45.0);
    BOOST_CHECK_EQUAL( "[[0.70711,0.70711,0.00000,0.00000][-0.70711,0.70711,0.00000,0.00000][0.00000,0.00000,1.00000,0.00000][0.00000,0.00000,0.00000,1.00000]]", m.toString() );
}
~~~

## Test case: test_rotation
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_rotation )
{
    auto axis = mt::MTCoordinates(1.0, -1.0, 2.0);
    auto m = mt::MTMatrix44::rotation(30.0, axis);
    BOOST_CHECK_EQUAL( "[[1.00000,-2.82181,0.70347,0.00000][1.13031,1.00000,-2.67953,0.00000][2.67953,-0.70347,3.53725,0.00000][0.00000,0.00000,0.00000,1.00000]]", m.toString() );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

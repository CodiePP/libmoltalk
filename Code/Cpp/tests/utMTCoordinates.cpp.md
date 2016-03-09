~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTCoordinates.hpp"
#include "MTMatrix53.hpp"
#include "MTMatrix44.hpp"
#include <iostream>
~~~

# Test suite: utMTCoordinates
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTCoordinates )
~~~

## Test case: test_ctor
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_ctor )
{
    mt::MTCoordinates _c(1.0, -2.0, 3.0);
    BOOST_CHECK_EQUAL( _c.x(), 1.0 );
    BOOST_CHECK_EQUAL( _c.y(), -2.0 );
    BOOST_CHECK_EQUAL( _c.z(), 3.0 );
}
~~~

## Test case: test_transformBy
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_transformBy )
{
    mt::MTCoordinates _c(1.0, -2.0, 3.0);
    mt::MTCoordinates _v(1.0, -2.0, 3.0);
    mt::MTMatrix53 _tr;
	_tr.atRowColValue(3, 0, 1.0);
	_tr.atRowColValue(3, 1,-1.0);
	_tr.atRowColValue(3, 2, 1.0);
	_tr.atRowColValue(4, 0, 1.0);
	_tr.atRowColValue(4, 1,-1.0);
	_tr.atRowColValue(4, 2, 1.0);
    _c.transformBy(_tr);
    BOOST_CHECK( _c == _v );
}
~~~

## Test case: test_rotateBy
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_rotateBy )
{
    mt::MTCoordinates _c(1.0, -2.0, 3.0);
    mt::MTCoordinates _c2 = _c * 2.0;
	mt::MTMatrix44 _r;
	_r.atRowColValue(0, 0, 2.0);
	_r.atRowColValue(1, 1, 2.0);
	_r.atRowColValue(2, 2, 2.0);
    _c.rotateBy(_r);
    //std::clog << "c: " << _c << std::endl;
    //std::clog << "c2: " << _c2 << std::endl;
    BOOST_CHECK( _c == _c2 );
}
~~~

## Test case: test_translateBy
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_translateBy )
{
    mt::MTCoordinates _c(1.0, -2.0, 3.0);
    mt::MTCoordinates _tr(1.0, 2.0, -3.0);
    mt::MTCoordinates _c2(2.0, 0.0, 0.0);
    _c.translateBy(_tr);
    BOOST_CHECK( _c == _c2 );
}
~~~

## Test case: test_distances
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_distances )
{
    mt::MTCoordinates _c1(1.0, -2.0, 3.0);
    mt::MTCoordinates _c2(-1.0, 2.0, -3.0);
    //	std::cout << "distance2To => " << _c1.distance2To(_c2) << std::endl;
    BOOST_CHECK_EQUAL( _c1.distance2To(_c2), 56.0 );
    BOOST_CHECK_EQUAL( _c1.distanceTo(_c2), 7.4833147735478827 );
}
~~~

## Test case: test_calculateDihedralAngleBetween_fails
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_calculateDihedralAngleBetween_fails )
{
    mt::MTCoordinates _c1(2.0, 1.0, 3.0);
    mt::MTCoordinates _c2(1.0, 2.0, -3.0);
    //mt::MTCoordinates _c3(-3.0, 2.0, -1.0);
    //mt::MTCoordinates _c4(-3.0, -1.0, -2.0);
    BOOST_CHECK_CLOSE_FRACTION( mt::MTCoordinates::calculateDihedralAngleBetween(_c1,_c2,_c1,_c2), 0.0, 0.00001 );
}
~~~

## Test case: test_calculateDihedralAngleBetween_simple
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_calculateDihedralAngleBetween_simple )
{
    mt::MTCoordinates _c1(2.0, 1.0, 3.0);
    mt::MTCoordinates _c2(1.0, 2.0, -3.0);
    //mt::MTCoordinates _c3(-3.0, 2.0, -1.0);
    //mt::MTCoordinates _c4(-3.0, -1.0, -2.0);
    BOOST_CHECK_CLOSE_FRACTION( mt::MTCoordinates::calculateDihedralAngleBetween(_c1,_c2,_c2,_c1), 0.0, 0.00001 );
}
~~~

## Test case: test_calculateDihedralAngleBetween
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_calculateDihedralAngleBetween )
{
    mt::MTCoordinates _c1(2.0, 1.0, 3.0);
    mt::MTCoordinates _c2(1.0, 2.0, -3.0);
    mt::MTCoordinates _c3(-3.0, 2.0, -1.0);
    mt::MTCoordinates _c4(-3.0, -1.0, -2.0);
    BOOST_CHECK_CLOSE_FRACTION( mt::MTCoordinates::calculateDihedralAngleBetween(_c1,_c2,_c3,_c4), 83.3362, 0.001 );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

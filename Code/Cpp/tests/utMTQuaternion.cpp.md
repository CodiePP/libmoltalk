~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"

#include "MTQuaternion.hpp"
~~~

# Test suite: utMTQuaternion
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTQuaternion )
~~~

## Test case: test_ctor
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_ctor )
{
	mt::MTQuaternion _q1;
	mt::MTQuaternion _q2(-2.0, 1.0, -3.3, 1.23456);

	BOOST_CHECK_EQUAL( _q1.x(), 0.0 );
	BOOST_CHECK_EQUAL( _q1.y(), 0.0 );
	BOOST_CHECK_EQUAL( _q1.z(), 0.0 );
	BOOST_CHECK_EQUAL( _q1.w(), 1.0 );
	BOOST_CHECK_EQUAL( _q2.x(), -2.0 );
	BOOST_CHECK_EQUAL( _q2.y(), 1.0 );
	BOOST_CHECK_EQUAL( _q2.z(), -3.3 );
	BOOST_CHECK_EQUAL( _q2.w(), 1.23456 );
}
~~~
## Test case: test_invert
TODO  :exclamation:
~~~ { .cpp }
/*
BOOST_AUTO_TEST_CASE( test_invert )
{
	mt::MTQuaternion _q1(-1.0, 2.0, 1.0, 1.5);
	mt::MTQuaternion _qi(1.0, -2.0, 3.3, 1.00456);

	mt::MTQuaternion _q2=_q1.invert(); // inverted

	BOOST_CHECK_EQUAL( _q2, _qi );

	mt::MTQuaternion _qb=_q2.invert(); // back 

	BOOST_CHECK_EQUAL( _qb, _q1 );
} */
~~~

## Test case: test_rotate
TODO  :exclamation:
~~~ { .cpp }
/*
BOOST_AUTO_TEST_CASE( test_rotate )
{
    BOOST_CHECK( false );
} */
~~~

## Test case: test_rotationMatrix
TODO  :exclamation:
~~~ { .cpp }
/*
BOOST_AUTO_TEST_CASE( test_rotationMatrix )
{
    BOOST_CHECK( false );
} */
~~~

## Test case: test_normalize
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_normalize )
{
	mt::MTQuaternion _q(-2.0, 1.0, -3.3, 1.23456);
	BOOST_CHECK_EQUAL( _q.x(), -2.0 );
	BOOST_CHECK_EQUAL( _q.y(), 1.0 );
	BOOST_CHECK_EQUAL( _q.z(), -3.3 );
	BOOST_CHECK_EQUAL( _q.w(), 1.23456 );
	_q.normalize();
	BOOST_CHECK_CLOSE_FRACTION( _q.magnitude2(), 1.0, 0.000001 );
}
~~~

## Test case: test_multiplyWith
TODO  :exclamation:
~~~ { .cpp }
/*
BOOST_AUTO_TEST_CASE( test_multiplyWith )
{
    BOOST_CHECK( false );
} */
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

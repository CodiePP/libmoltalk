
~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTVector.hpp"
#include <cmath>
#include <iostream>
~~~

# Test suite: utMTVector
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTVector )
~~~

## Test case: test_ctor
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_ctor )
{
    mt::MTVector _v(4);
    BOOST_CHECK_EQUAL( _v.atDim(0), 0 );
    BOOST_CHECK_EQUAL( _v.atDim(1), 0 );
    BOOST_CHECK_EQUAL( _v.atDim(2), 0 );
    BOOST_CHECK_EQUAL( _v.atDim(3), 0 );
    BOOST_CHECK_EQUAL( _v.dimensions(), 4 );
}
~~~

## Test case: test_length
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_length )
{
    mt::MTVector _v(2);
    BOOST_CHECK( fabs(0 - _v.length()) < 0.000001 );
    _v.atDim(0, 0.0);
    _v.atDim(1, 1.0);
    BOOST_CHECK_EQUAL( _v.length(), 1 );
}
~~~

## Test case: test_differenceTo
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_differenceTo )
{
    mt::MTVector _v1(2);
    _v1.atDim(0,-1.0); _v1.atDim(1,2.0);
    mt::MTVector _v2(2);
    _v2.atDim(0,1.0); _v2.atDim(1,-2.0);

    mt::MTVector _vt(2);
    BOOST_CHECK_EQUAL( _v1.differenceTo(_v1), _vt );
    BOOST_CHECK_EQUAL( _v2.differenceTo(_v2), _vt );
    _vt.atDim(0,2.0); _vt.atDim(1,-4.0);
    BOOST_CHECK_EQUAL( _v1.differenceTo(_v2), _vt );
}
~~~

## Test case: test_euklideanDistanceTo
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_euklideanDistanceTo )
{
    mt::MTVector _v1(2);
    _v1.atDim(0,-1.0); _v1.atDim(1,2.0);
    mt::MTVector _v2(2);
    _v2.atDim(0,1.0); _v2.atDim(1,-2.0);
    BOOST_CHECK_CLOSE_FRACTION( _v1.euklideanDistanceTo(_v2) , sqrt(20.0), 0.0001 );
}
~~~

## Test case: test_add
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_add )
{
    mt::MTVector _v1(2);
    mt::MTVector _v2(2);
    _v2.atDim(0,1.0); _v2.atDim(1,-1.0);
    mt::MTVector _vt(2);
    _vt.atDim(0,3.0); _vt.atDim(1,-3.0);
    mt::MTVector _v3 = (_v1 + _v2 + _v2 + _v2);
    BOOST_CHECK( (_v1 + _v2 + _v2 + _v2) == _vt ); // transient
    BOOST_CHECK( _v1.add(_v2).add(_v2).add(_v2) == _vt ); // inplace
}
~~~

## Test case: test_normalize
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_normalize )
{
    mt::MTVector _v(2);
    _v.atDim(0,1.0); _v.atDim(1,-1.0);
    BOOST_CHECK_CLOSE_FRACTION( _v.length(), 1.4142, 0.001 );
    BOOST_CHECK_CLOSE_FRACTION( _v.normalize().length(), 1.0, 0.001 );
}
~~~

## Test case: test_scaleByScalar
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_scaleByScalar )
{
    mt::MTVector _v(2);
    _v.atDim(0,1.0); _v.atDim(1,-1.0);
    mt::MTVector _vt(2);
    _vt.atDim(0,4.0); _vt.atDim(1,-4.0);
	//std::clog << _v << std::endl;
    BOOST_CHECK( (_v * 4.0) == _vt ); // transient
	//std::clog << _v << std::endl;
    _v *= 4.0; // inplace
	//std::clog << _v << std::endl;
    BOOST_CHECK( _v == _vt );
}
~~~

## Test case: test_angleBetween2
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_angleBetween2 )
{
/* [ 1   .* [-2
    -1 ]     -1 ]
*/
    mt::MTVector _v1(2);
    _v1.atDim(0,1.0); _v1.atDim(1,-1.0);
    mt::MTVector _v2(2);
    _v2.atDim(0,-2.0); _v2.atDim(1,-1.0);
    BOOST_CHECK_CLOSE_FRACTION( _v1.scalarProductBy(_v1) , 2.0, 0.0001 );
    BOOST_CHECK_CLOSE_FRACTION( _v1.scalarProductBy(_v2) ,-1.0, 0.0001 );
	std::clog << "_v1.angleBetween(_v1)" << std::endl;
    BOOST_CHECK_CLOSE_FRACTION( _v1.angleBetween(_v1) , 0.0, 0.001 );
	std::clog << "_v2.angleBetween(_v2)" << std::endl;
    BOOST_CHECK_CLOSE_FRACTION( _v2.angleBetween(_v2) , 0.0, 0.001 );
	std::clog << "_v1.angleBetween(_v2)" << std::endl;
    BOOST_CHECK_CLOSE_FRACTION( _v1.angleBetween(_v2) , 108.434949, 0.0001 );
}
~~~

## Test case: test_angleBetween3
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_angleBetween3 )
{
    mt::MTVector _v1(3);
    _v1.atDim(0,-1.0); _v1.atDim(1,-2.0); _v1.atDim(2,-3.0);
    mt::MTVector _v2(3);
    _v2.atDim(0,1.0); _v2.atDim(1,2.0); _v2.atDim(2,3.0);
    BOOST_CHECK_CLOSE_FRACTION( _v1.scalarProductBy(_v1) , 14.0, 0.0001 );
    BOOST_CHECK_CLOSE_FRACTION( _v1.scalarProductBy(_v2) , -14.0, 0.0001 );
    BOOST_CHECK_CLOSE_FRACTION( _v1.angleBetween(_v1) , 0.0, 0.0001 );
    BOOST_CHECK_CLOSE_FRACTION( _v2.angleBetween(_v2) , 0.0, 0.0001 );
    BOOST_CHECK_CLOSE_FRACTION( _v1.angleBetween(_v2) , 180.0, 0.0001 );
}
~~~

## Test case: test_scalarProductBy
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_scalarProductBy )
{
/* [ 1   .* [ 2
    -1 ]      1 ]
*/
    mt::MTVector _v1(2);
    _v1.atDim(0,1.0); _v1.atDim(1,-1.0);
    mt::MTVector _v2(2);
    _v2.atDim(0,2.0); _v2.atDim(1,1.0);
    BOOST_CHECK_CLOSE_FRACTION( _v1.scalarProductBy(_v2), 1.0, 0.00001 );
}
~~~

## Test case: test_vectorProductBy
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_vectorProductBy )
{
/* [ 1     [ 2
     1   x   1  
    -2 ]     1 ]
*/
    mt::MTVector _v1(3);
    _v1.atDim(0,1.0); _v1.atDim(1,1.0); _v1.atDim(2,-2.0);
    mt::MTVector _v2(3);
    _v2.atDim(0,2.0); _v2.atDim(1,1.0); _v2.atDim(2,1.0);
    mt::MTVector _vp = _v1.vectorProductBy(_v2);
    //std::clog << _vp << std::endl;
    mt::MTVector _vt(4);
    _vt.atDim(0,3.0); _vt.atDim(1,-5.0); _vt.atDim(2,-1.0); _vt.atDim(3,1.0);
    BOOST_CHECK( _vp == _vt );
}
~~~

## Test case: test_mixedProductBy
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test_mixedProductBy )
{
/* [ 1     [ 2     [ 3
     1   x   1   x  -1
    -2 ]     1 ]    -1 ]
*/
    mt::MTVector _v1(3);
    _v1.atDim(0,1.0); _v1.atDim(1,1.0); _v1.atDim(2,-2.0);
    mt::MTVector _v2(3);
    _v2.atDim(0,2.0); _v2.atDim(1,1.0); _v2.atDim(2,1.0);
    mt::MTVector _v3(3);
    _v3.atDim(0,3.0); _v3.atDim(1,-1.0); _v3.atDim(2,-1.0);
    double _mixp = _v1.mixedProductBy(_v2, _v3);
    BOOST_CHECK_CLOSE_FRACTION( _mixp, 15.0, 0.00001 );
}
~~~

## Test case: string_output
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( string_output )
{
/* [ 1     [ 2
     1   x   1  
    -2 ]     1 ]
*/
    mt::MTVector _v1(3);
    _v1.atDim(0,1.0); _v1.atDim(1,1.0); _v1.atDim(2,-2.0);
    mt::MTVector _v2(3);
    _v2.atDim(0,2.0); _v2.atDim(1,1.0); _v2.atDim(2,1.0);
    mt::MTVector _vp = _v1.vectorProductBy(_v2);
    std::ostringstream ss;
    ss << _vp;
    BOOST_CHECK_EQUAL( "[3, -5, -1, 1]", ss.str() );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

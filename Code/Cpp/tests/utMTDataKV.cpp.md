Copyright 2016 by Alexander Diemand

[LICENSE](../../LICENSE)

~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"

#include "MTResidue.hpp"
#include "MTResidueFactory.hpp"
#include "MTAtom.hpp"
#include "MTAtomFactory.hpp"
#include "MTChain.hpp"
#include "MTChainFactory.hpp"
#include "MTStructure.hpp"
#include "MTStructureFactory.hpp"
#include "MTMatrix.hpp"
#include "MTMatrix44.hpp"
#include "MTMatrix53.hpp"
#include "MTDataKV.hpp"

#include <iostream>
~~~

# Test suite: utMTDataKV
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTDataKV )

static int got_dtor = 0;
class testM : public mt::MTMatrix
{
public:
	testM(int d) : mt::MTMatrix(d,d) {}
	virtual ~testM() { ++got_dtor; }
};
~~~

## Test case: only_insert_once
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( only_insert_once )
{
	mt::MTMatrix _m1(3,3);
	mt::MTMatrix _m2(3,3);
	mt::MTDataKV _kv;
	BOOST_CHECK( _kv.set("t1", _m1) );
	BOOST_CHECK(!_kv.set("t1", _m2) );
}
~~~

## Test case: unset_value
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( unset_value )
{
	mt::MTMatrix _m1(3,3);
	mt::MTMatrix _m2(3,3);
	mt::MTDataKV _kv;
	BOOST_CHECK( _kv.set("t1", _m1) );
	BOOST_CHECK(!_kv.set("t1", _m2) );
	BOOST_CHECK( _kv.unset("t1") );
	BOOST_CHECK( _kv.set("t1", _m2) );
	BOOST_CHECK(!_kv.set("t1", _m1) );
}
~~~

## Test case: track_destruction
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( track_destruction )
{
	{
		testM t1(34);
		mt::MTMatrix _m(t1);
		mt::MTMatrix _m2(34,34);
		mt::MTDataKV _kv;
		BOOST_CHECK( _kv.set("t1", _m) );
		BOOST_CHECK( _kv.get("t1", _m2) );
	}
	BOOST_CHECK_EQUAL( 1, got_dtor );
}
~~~

## Test case: get_set_MTVector
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTVector )
{
	mt::MTDataKV _kv;
	mt::MTVector _s(3);
	_s.atDim(1, -2.2);
	mt::MTVector _g(3);
	BOOST_CHECK( _kv.set("t1", _s) );
	std::clog << " before s=" << _s << std::endl;
	BOOST_CHECK( _kv.get("t1", _g) );
	std::clog << " after g=" << _g << std::endl;
	BOOST_CHECK_EQUAL( -2.2, _g.atDim(1) );
	std::clog << "utMTDataKV::get_set_MTVector" << std::endl;
}
~~~

## Test case: get_set_string
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_string )
{
	mt::MTDataKV _kv;
	std::string const _s("hello world");
	std::string _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( "hello world", _g );
	std::clog << "utMTDataKV::get_set_string" << std::endl;
}
~~~

## Test case: get_set_double
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_double )
{
	mt::MTDataKV _kv;
	double _s = 42.0;
	double _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( 42.0, _g );
	std::clog << "utMTDataKV::get_set_double" << std::endl;
}
~~~

## Test case: get_set_float
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_float )
{
	mt::MTDataKV _kv;
	float _s = 42.0f;
	float _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( 42.0f, _g );
	std::clog << "utMTDataKV::get_set_float" << std::endl;
}
~~~

## Test case: get_set_int
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_int )
{
	mt::MTDataKV _kv;
	int _s = -42;
	int _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( -42, _g );
	std::clog << "utMTDataKV::get_set_int" << std::endl;
}
~~~

## Test case: get_set_long
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_long )
{
	mt::MTDataKV _kv;
	long _s = -42;
	long _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( -42, _g );
	std::clog << "utMTDataKV::get_set_long" << std::endl;
}
~~~

## Test case: get_set_MTCoordinates
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTCoordinates )
{
	mt::MTDataKV _kv;
	mt::MTCoordinates _s;
	_s.set(0.0, -2.2, 3.8);
	mt::MTCoordinates _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( -2.2, _g.y() );
	std::clog << "utMTDataKV::get_set_MTCoordinates" << std::endl;
}
~~~

## Test case: get_set_MTMatrix
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTMatrix )
{
	mt::MTDataKV _kv;
	mt::MTMatrix _s(3,3);
	_s.atRowColValue(1,2, -2.2);
	mt::MTMatrix _g(3,3);
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( -2.2, _g.atRowCol(1,2) );
	std::clog << "utMTDataKV::get_set_MTMatrix" << std::endl;
}
~~~

## Test case: get_set_MTMatrix44
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTMatrix44 )
{
	mt::MTDataKV _kv;
	mt::MTMatrix44 _s;
	_s.atRowColValue(1,2, -2.2);
	mt::MTMatrix44 _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( -2.2, _g.atRowCol(1,2) );
	std::clog << "utMTDataKV::get_set_MTMatrix44" << std::endl;
}
~~~

## Test case: get_set_MTMatrix53
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTMatrix53 )
{
	mt::MTDataKV _kv;
	mt::MTMatrix53 _s;
	_s.atRowColValue(1,2, -2.2);
	mt::MTMatrix53 _g;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK_EQUAL( -2.2, _g.atRowCol(1,2) );
	std::clog << "utMTDataKV::get_set_MTMatrix53" << std::endl;
}
~~~

## Test case: get_set_many
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_many )
{
	mt::MTDataKV _kv;
	mt::MTMatrix53 _s;
	_s.atRowColValue(1,2, -2.2);
	BOOST_CHECK( _kv.set("m53", _s) );
	double s_d = 42.42;
	BOOST_CHECK( _kv.set("d", s_d) );
	long s_l = -42L;
	BOOST_CHECK( _kv.set("l", s_l) );

	long g_l;
	BOOST_CHECK( _kv.get("l", g_l) );
	mt::MTMatrix53 g_m53;
	BOOST_CHECK( _kv.get("m53", g_m53) );
	double g_d;
	BOOST_CHECK( _kv.get("d", g_d) );
}
~~~

## Test case: get_set_MTResidue
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTResidue )
{
	mt::MTDataKV _kv;
	mt::MTResidueFactory _factory;
	auto _s = _factory.newResidue(42, "XYZ");
	mt::MTResidue * _g = nullptr;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK( _g != nullptr );
	BOOST_CHECK_EQUAL( 42, _g->number() );
	std::clog << "utMTDataKV::get_set_MTResidue: " << _g->name() << std::endl;
}
~~~

## Test case: get_set_MTAtom
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTAtom )
{
	mt::MTDataKV _kv;
	mt::MTAtomFactory _factory;
	auto _s = _factory.newAtom(42, "XYZ");
	mt::MTAtom * _g = nullptr;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK( _g != nullptr );
	BOOST_CHECK_EQUAL( 42, _g->serial() );
	std::clog << "utMTDataKV::get_set_MTAtom: " << _g->name() << std::endl;
}
~~~

## Test case: get_set_MTChain
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTChain )
{
	mt::MTDataKV _kv;
	mt::MTChainFactory _factory;
	auto _s = _factory.newChain(65);
	mt::MTChain * _g = nullptr;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK( _g != nullptr );
	BOOST_CHECK_EQUAL( 65, _g->number() );
	std::clog << "utMTDataKV::get_set_MTChain: " << _g->name() << std::endl;
}
~~~

## Test case: get_set_MTStructure
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( get_set_MTStructure )
{
	mt::MTDataKV _kv;
	mt::MTStructureFactory _factory;
	auto _s = _factory.newStructure();
	mt::MTStructure * _g = nullptr;
	BOOST_CHECK( _kv.set("t1", _s) );
	BOOST_CHECK( _kv.get("t1", _g) );
	BOOST_CHECK( _g != nullptr );
	std::clog << "utMTDataKV::get_set_MTStructure: " << _g->pdbcode() << std::endl;
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

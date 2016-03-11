Copyright 2016 by Alexander Diemand

[LICENSE](../../LICENSE)

TODO :exclamation: 

more tests needed!

~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTAtomFactory.hpp"
#include "MTAtom.hpp"
#include "MTChain.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTAtom
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTAtom )
~~~

## Test case: setters_getters
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( setters_getters )
{
	mt::MTAtomFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	inst->setName("test");
	inst->setSerial(101);

	BOOST_CHECK_EQUAL( 101, inst->serial() );
	BOOST_CHECK_EQUAL( "test", inst->name() );
}
~~~

## Test case: manipulate_bonds
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( manipulate_bonds )
{
	mt::MTAtomFactory _factory;
	auto a1 = _factory.newAtom(42, "ATM1");
	BOOST_CHECK( bool(a1) );
	auto a2 = _factory.newAtom(43, "ATM2");
	BOOST_CHECK( bool(a2) );

	a1->bondTo(a2);
	auto _blist = a1->allBondedAtoms();
	BOOST_CHECK_EQUAL( 1, _blist.size() );
	_blist = a2->allBondedAtoms();
	BOOST_CHECK_EQUAL( 0, _blist.size() );
	a2->bondTo(a1);
	_blist = a2->allBondedAtoms();
	BOOST_CHECK_EQUAL( 1, _blist.size() );
}
~~~

## Test case: coordinates
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( coordinates )
{
	mt::MTAtomFactory _factory;
	auto a = _factory.newAtom(42, "ATM1");
	auto c = a->coords();
	BOOST_CHECK_EQUAL( 0.0, c.x() );
	BOOST_CHECK_EQUAL( 0.0, c.y() );
	BOOST_CHECK_EQUAL( 0.0, c.z() );
}
~~~

## Test case: rotate
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( rotate )
{
	mt::MTAtomFactory _factory;
	auto a = _factory.newAtom(42, "ATM1");
	a->setXYZB(-1.0, 2.0, 0.5, 0.77);
	mt::MTMatrix44 m;
	m.atRowColValue(0,0, 1.5);
	m.atRowColValue(1,1, 1.5);
	m.atRowColValue(2,2, 1.5);
	a->rotateBy(m);

	auto c = a->coords();
	BOOST_CHECK_EQUAL( -1.5, c.x() );
	BOOST_CHECK_EQUAL( 3.0, c.y() );
	BOOST_CHECK_EQUAL( 0.75, c.z() );
}
~~~

## Test case: translate
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( translate )
{
	mt::MTAtomFactory _factory;
	auto a = _factory.newAtom(42, "ATM1");
	a->setXYZB(-1.0, 2.0, 0.5, 0.77);
	mt::MTCoordinates tr(1.0, 1.0, 1.0);
	a->translateBy(tr);

	auto c = a->coords();
	BOOST_CHECK_EQUAL( 0.0, c.x() );
	BOOST_CHECK_EQUAL( 3.0, c.y() );
	BOOST_CHECK_EQUAL( 1.5, c.z() );
}
~~~

## Test case: transform
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( transform )
{
	mt::MTAtomFactory _factory;
	auto a = _factory.newAtom(42, "ATM1");
	a->setXYZB(-1.0, 2.0, 0.5, 0.77);
	mt::MTMatrix53 m;
	m.atRowColValue(0,0, -1.5); // diagonals
	m.atRowColValue(1,1, -1.5);
	m.atRowColValue(2,2, -1.5);
	m.atRowColValue(3,0, 1.0); // origin x
	m.atRowColValue(3,1, 1.0);
	m.atRowColValue(3,2, 1.0);
	m.atRowColValue(4,0, 1.0); // translation x
	m.atRowColValue(4,1, 1.0);
	m.atRowColValue(4,2, 1.0);
	a->transformBy(m);

	auto c = a->coords();
	// (-1.0 - 1.0) * -1.50 + 1.0
	BOOST_CHECK_EQUAL( 4.0, c.x() );
	// (2.0 - 1.0) * -1.50 + 1.0
	BOOST_CHECK_EQUAL( -0.5, c.y() );
	// (0.5 - 1.0) * -1.50 + 1.0
	BOOST_CHECK_EQUAL( 1.75, c.z() );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

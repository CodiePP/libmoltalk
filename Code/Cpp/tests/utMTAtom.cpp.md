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

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

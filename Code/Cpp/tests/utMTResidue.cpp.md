~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTResidueFactory.hpp"
#include "MTResidue.hpp"
#include "MTAtomFactory.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTResidue
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTResidue )
~~~

## Test case: default_factory
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( default_factory )
{
	mt::MTResidueFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	//BOOST_CHECK_EQUAL( inst, std::dynamic_pointer_cast<mt::MTResidue>(inst) );
}
~~~

## Test case: manipulate_atoms
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( manipulate_atoms )
{
	mt::MTResidueFactory _rfactory;
	auto r1 = _rfactory.newInstance();
	BOOST_CHECK( bool(r1) );

	mt::MTAtomFactory _afactory;
	r1->addAtom( _afactory.newAtom(42, "ATM1", -23.78, 14.23, 0.781, 14.00) );
	r1->addAtom( _afactory.newAtom(43, "ATM2", -32.78, 12.23, 2.781, 14.42) );

	BOOST_CHECK_EQUAL( 2, r1->allAtoms([](mt::MTAtom * a) { return; }) );

	auto a1 = r1->getAtom(42);
	BOOST_CHECK( bool(a1) );
	auto a2 = r1->getAtom("ATM");
	BOOST_CHECK(! bool(a2) );
	a2 = r1->getAtom("ATM2");
	BOOST_CHECK( bool(a2) );

	r1->removeAtom("ATM2");
	a2 = r1->getAtom("ATM2");
	BOOST_CHECK(! bool(a2) );
	r1->removeAtom(nullptr);
	a1 = r1->getAtom("ATM1");
	BOOST_CHECK( bool(a1) );
	r1->removeAtom(r1->getAtom(42));
	a1 = r1->getAtom("ATM1");
	BOOST_CHECK(! bool(a1) );

	BOOST_CHECK_EQUAL( 0, r1->allAtoms([](mt::MTAtom * a) { return; }) );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

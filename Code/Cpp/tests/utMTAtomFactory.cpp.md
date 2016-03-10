~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTAtomFactory.hpp"
#include "MTAtom.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTAtomFactory

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTAtomFactory )
~~~

## Test case: 
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( default_factory )
{
	mt::MTAtomFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTAtom*>(inst) );
}
~~~

## Test case: set_own_factory
~~~ { .cpp }
class MyAtom : public mt::MTAtom
{
public:
	MyAtom() : mt::MTAtom() {}
	virtual ~MyAtom() {}
};

BOOST_AUTO_TEST_CASE( set_own_factory )
{
	mt::MTAtomFactory _factory;
	_factory.setFactory([]()->mt::MTAtom*{ return new MyAtom(); });
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<MyAtom*>(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTAtom*>(inst) );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

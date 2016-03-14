~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTResidueFactory.hpp"
#include "MTResidue.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTResidueFactory
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTResidueFactory )
~~~

## Test case: default_factory
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( default_factory )
{
	mt::MTResidueFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	//BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTResidue>(inst) );
}
~~~

## Test case: set_own_factory
~~~ { .cpp }
class MyResidue : public mt::MTResidue
{
public:
	MyResidue() : mt::MTResidue() {}
	virtual ~MyResidue() {}
};

BOOST_AUTO_TEST_CASE( set_own_factory )
{
	mt::MTResidueFactory _factory;
	_factory.setFactory([]()->mt::MTResidue*{ return new MyResidue(); });
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<MyResidue*>(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTResidue*>(inst) );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

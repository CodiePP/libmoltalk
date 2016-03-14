~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTChainFactory.hpp"
#include "MTChain.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTChainFactory
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTChainFactory )

BOOST_AUTO_TEST_CASE( default_factory )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTChain*>(inst) );
}
~~~

## Test case: set_own_factory
~~~ { .cpp }
class MyChain : public mt::MTChain
{
public:
	MyChain(char c) : mt::MTChain(c) {}
	virtual ~MyChain() {}
};

BOOST_AUTO_TEST_CASE( set_own_factory )
{
	mt::MTChainFactory _factory;
	_factory.setFactory([](char c)->mt::MTChain*{ return new MyChain(c); });
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<MyChain*>(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTChain*>(inst) );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

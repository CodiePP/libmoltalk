~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"

#include "MTStructureFactory.hpp"
#include "MTStructure.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTStructureFactory
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTStructureFactory )
~~~

## Test case: default_factory
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( default_factory )
{
	mt::MTStructureFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	//BOOST_CHECK_EQUAL( inst, std::dynamic_pointer_cast<mt::MTStructure>(inst) );
}
~~~

## Test case: set_own_factory
~~~ { .cpp }
class MyStructure : public mt::MTStructure
{
public:
	MyStructure() : mt::MTStructure() , _answer(42) {}
	virtual ~MyStructure() {}

	int _the_answer() const { return _answer; }
private:
	int _answer;
};

BOOST_AUTO_TEST_CASE( set_own_factory )
{
	mt::MTStructureFactory _factory;
	_factory.setFactory([]()->mt::MTStructure*{ return new MyStructure(); });
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<MyStructure*>(inst) );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTStructure*>(inst) );
}
~~~

## Test case: set_own_factory_hey_its_a_static
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( set_own_factory_hey_its_a_static )
{
	mt::MTStructureFactory _factory;
	_factory.setFactory([]()->mt::MTStructure*{ return new MyStructure(); });
	mt::MTStructureFactory _factory2;

	auto inst = _factory2.newInstance();
	BOOST_CHECK( bool(inst) );
	BOOST_CHECK_EQUAL( 42, dynamic_cast<MyStructure*>(inst)->_the_answer() );
	BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTStructure*>(inst) );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

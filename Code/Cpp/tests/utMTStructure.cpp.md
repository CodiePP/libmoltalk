~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTStructureFactory.hpp"
#include "MTStructure.hpp"
#include "MTChain.hpp"

#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTStructure
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTStructure )
~~~

## Test case: manipulate_models
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( manipulate_models )
{
	mt::MTStructureFactory _factory;
	auto strx = _factory.newInstance();
	BOOST_CHECK( bool(strx) );

	BOOST_CHECK_EQUAL( 1, strx->models() );
	BOOST_CHECK_EQUAL( 1, strx->currentModel() );
	auto c1 = new mt::MTChain('A');
	strx->addChain(c1);
	strx->addModel();
	BOOST_CHECK_EQUAL( 2, strx->models() );
	BOOST_CHECK_EQUAL( 2, strx->currentModel() );
	auto c2 = new mt::MTChain('B');
	strx->addChain(c2);
	BOOST_CHECK_EQUAL( 1, strx->switchToModel(1) );
	BOOST_CHECK( bool(strx->getChain(65)) );
	BOOST_CHECK_EQUAL( 2, strx->switchToModel(2) );
	BOOST_CHECK( bool(strx->getChain(66)) );

	strx->removeModel();
	BOOST_CHECK_EQUAL( 1, strx->models() );
	BOOST_CHECK_EQUAL( 1, strx->currentModel() );
	strx->removeModel();
	BOOST_CHECK_EQUAL( 1, strx->models() );
	BOOST_CHECK_EQUAL( 1, strx->currentModel() );
	BOOST_CHECK_EQUAL( 1, strx->switchToModel(3) );
	BOOST_CHECK_EQUAL( 1, strx->models() );
	BOOST_CHECK_EQUAL( 1, strx->currentModel() );
	strx->addModel();
	BOOST_CHECK_EQUAL( 2, strx->switchToModel(2) );
	BOOST_CHECK_EQUAL( 2, strx->models() );
	BOOST_CHECK_EQUAL( 2, strx->currentModel() );
	BOOST_CHECK_EQUAL( 1, strx->switchToModel(1) );
	BOOST_CHECK_EQUAL( 2, strx->models() );
	BOOST_CHECK_EQUAL( 1, strx->currentModel() );
}
~~~

## Test case: manipulate_chains
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( manipulate_chains )
{
	mt::MTStructureFactory _factory;
	auto strx = _factory.newInstance();

	auto c1 = strx->getChain(65);
	BOOST_CHECK( ! bool(c1) );

	auto c2 = new mt::MTChain('A');
	strx->addChain(c2);

	c1=nullptr;
	c1 = strx->getChain(65);
	BOOST_CHECK( bool(c1) );
	BOOST_CHECK_EQUAL( c1, c2 );

	strx->removeChain(c2);
	c1=nullptr;
	c1 = strx->getChain(65);
	BOOST_CHECK( ! bool(c1) );
}
~~~

## Test case: descriptors
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( descriptors )
{
	mt::MTStructureFactory _factory;
	auto strx = _factory.newInstance();
	strx->setDescriptor("INT", int(42));
	strx->setDescriptor("DBL", double(42.42));
	strx->setDescriptor("STR", std::string("hello world."));

	int _i; double _d; std::string _s;
	BOOST_CHECK( strx->getDescriptor("INT", _i) );
	BOOST_CHECK( strx->getDescriptor("DBL", _d) );
	BOOST_CHECK( strx->getDescriptor("STR", _s) );
	BOOST_CHECK(!strx->getDescriptor("some", _s) );
	BOOST_CHECK(!strx->getDescriptor("int", _i) );
	BOOST_CHECK(!strx->getDescriptor("dbl", _d) );
	BOOST_CHECK(!strx->getDescriptor("str", _s) );
	BOOST_CHECK_EQUAL( 42, _i );
	BOOST_CHECK_EQUAL( 42.42, _d );
	BOOST_CHECK_EQUAL( "hello world.", _s );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

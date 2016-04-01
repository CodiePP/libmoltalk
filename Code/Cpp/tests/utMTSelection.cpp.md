~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTSelection.hpp"
#include "MTChain.hpp"
#include "MTChainFactory.hpp"
#include "MTResidue.hpp"
#include "MTResidueFactory.hpp"

#include <iostream>
~~~

# Test suite: utMTSelection

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTSelection )
~~~

## Test case: add_once
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( add_once )
{
        mt::MTChainFactory _cf;
        mt::MTChain * c = _cf.newChain('A');
	mt::MTSelection _sel(c);
        mt::MTResidueFactory _rf;
        mt::MTResidue * r = _rf.newResidue(1, "ALA");
        c->addResidue(r);
        _sel.addResidue(r);
        _sel.addResidue(r);
        _sel.addResidue(r);
        _sel.addResidue(r);
        _sel.addResidue(r);
        BOOST_CHECK_EQUAL( 1, _sel.count() );
        BOOST_CHECK( _sel.containsResidue(r) );
}
~~~

## Test case: remove_once
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( remove_once )
{
        mt::MTChainFactory _cf;
        mt::MTChain * c = _cf.newChain('A');
	mt::MTSelection _sel(c);
        mt::MTResidueFactory _rf;
        mt::MTResidue * r = _rf.newResidue(1, "ALA");
        c->addResidue(r);
        BOOST_CHECK_EQUAL( 0, _sel.count() );
        _sel.addResidue(r);
        BOOST_CHECK_EQUAL( 1, _sel.count() );
        _sel.removeResidue(r);
        _sel.removeResidue(r);
        _sel.removeResidue(r);
        _sel.removeResidue(r);
        BOOST_CHECK_EQUAL( 0, _sel.count() );
}
~~~

## Test case: set_diff
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( set_diff )
{
        mt::MTChainFactory _cf;
        mt::MTChain * c = _cf.newChain('A');
	mt::MTSelection _sel1(c);
	mt::MTSelection _sel2(c);
        mt::MTResidueFactory _rf;
        mt::MTResidue * r1 = _rf.newResidue(1, "ALA");
        mt::MTResidue * r2 = _rf.newResidue(2, "CYS");
        c->addResidue(r1);
        c->addResidue(r2);
        BOOST_CHECK_EQUAL( 0, _sel1.count() );
        _sel1.addResidue(r1);
        _sel1.addResidue(r2);
        BOOST_CHECK_EQUAL( 2, _sel1.count() );
        _sel2.addResidue(r2);
        BOOST_CHECK_EQUAL( 1, _sel2.count() );
        _sel1.setDifference(&_sel2);
        BOOST_CHECK_EQUAL( 1, _sel1.count() );
        BOOST_CHECK_EQUAL( 1, _sel2.count() );
        BOOST_CHECK( _sel1.containsResidue(r1) );
        BOOST_CHECK( _sel2.containsResidue(r2) );
}
~~~

## Test case: set_union
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( set_union )
{
        mt::MTChainFactory _cf;
        mt::MTChain * c = _cf.newChain('A');
	mt::MTSelection _sel1(c);
	mt::MTSelection _sel2(c);
        mt::MTResidueFactory _rf;
        mt::MTResidue * r1 = _rf.newResidue(1, "ALA");
        mt::MTResidue * r2 = _rf.newResidue(2, "CYS");
        c->addResidue(r1);
        c->addResidue(r2);
        BOOST_CHECK_EQUAL( 0, _sel1.count() );
        _sel1.addResidue(r1);
        BOOST_CHECK_EQUAL( 1, _sel1.count() );
        _sel2.addResidue(r2);
        BOOST_CHECK_EQUAL( 1, _sel2.count() );
        _sel1.setUnion(&_sel2);
        BOOST_CHECK_EQUAL( 2, _sel1.count() );
        BOOST_CHECK_EQUAL( 1, _sel2.count() );
        BOOST_CHECK( _sel1.containsResidue(r1) );
        BOOST_CHECK( _sel1.containsResidue(r2) );
        BOOST_CHECK( _sel2.containsResidue(r2) );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

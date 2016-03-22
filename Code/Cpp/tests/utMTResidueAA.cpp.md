~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTResidueFactory.hpp"
#include "MTResidueAA.hpp"
#include "MTAtomFactory.hpp"

#include <list>
#include <tuple>
#include <iostream>
#include <typeinfo>
~~~

# Test suite: utMTResidueAA
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTResidueAA )
~~~

## Test case: default_factory
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( set_factory )
{
	mt::MTResidueFactory _factory;
	_factory.setFactory([]()->mt::MTResidue* { return new mt::MTResidueAA(); });
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
        BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTResidueAA*>(inst) );
}
~~~

## Test case: convert 3-letter code to 1-letter code
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( convert3to1Code )
{
	mt::MTResidueFactory _factory;
	_factory.setFactory([]()->mt::MTResidue* { return new mt::MTResidueAA(); });
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
        BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTResidueAA*>(inst) );

#define stds(x) std::string(x)
	std::list<std::tuple<std::string, std::string>> l3to1 = {
	  std::make_tuple(stds("ALA"), stds("A"))
	, std::make_tuple(stds("ARG"), stds("R"))
	, std::make_tuple(stds("ASN"), stds("N"))
	, std::make_tuple(stds("ASP"), stds("D"))
	, std::make_tuple(stds("CYS"), stds("C"))
	, std::make_tuple(stds("GLN"), stds("Q"))
	, std::make_tuple(stds("GLU"), stds("E"))
	, std::make_tuple(stds("GLY"), stds("G"))
	, std::make_tuple(stds("HIS"), stds("H"))
	, std::make_tuple(stds("ILE"), stds("I"))
	, std::make_tuple(stds("LEU"), stds("L"))
	, std::make_tuple(stds("LYS"), stds("K"))
	, std::make_tuple(stds("MET"), stds("M"))
	, std::make_tuple(stds("PHE"), stds("F"))
	, std::make_tuple(stds("PRO"), stds("P"))
	, std::make_tuple(stds("SER"), stds("S"))
	, std::make_tuple(stds("THR"), stds("T"))
	, std::make_tuple(stds("TRP"), stds("W"))
	, std::make_tuple(stds("TYR"), stds("Y"))
	, std::make_tuple(stds("VAL"), stds("V")) };
#undef stds	

	for (auto e : l3to1) {
		std::string c1 = mt::MTResidueAA::translate3to1Code(std::get<0>(e));
		BOOST_CHECK_EQUAL( c1, std::get<1>(e) );
	}
}
~~~

## Test case: convert 1-letter code to 3-letter code
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( convert1to3Code )
{
	mt::MTResidueFactory _factory;
	_factory.setFactory([]()->mt::MTResidue* { return new mt::MTResidueAA(); });
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
        BOOST_CHECK_EQUAL( inst, dynamic_cast<mt::MTResidueAA*>(inst) );

#define stds(x) std::string(x)
	std::list<std::tuple<std::string, std::string>> l3to1 = {
	  std::make_tuple(stds("ALA"), stds("A"))
	, std::make_tuple(stds("ARG"), stds("R"))
	, std::make_tuple(stds("ASN"), stds("N"))
	, std::make_tuple(stds("ASP"), stds("D"))
	, std::make_tuple(stds("CYS"), stds("C"))
	, std::make_tuple(stds("GLN"), stds("Q"))
	, std::make_tuple(stds("GLU"), stds("E"))
	, std::make_tuple(stds("GLY"), stds("G"))
	, std::make_tuple(stds("HIS"), stds("H"))
	, std::make_tuple(stds("ILE"), stds("I"))
	, std::make_tuple(stds("LEU"), stds("L"))
	, std::make_tuple(stds("LYS"), stds("K"))
	, std::make_tuple(stds("MET"), stds("M"))
	, std::make_tuple(stds("PHE"), stds("F"))
	, std::make_tuple(stds("PRO"), stds("P"))
	, std::make_tuple(stds("SER"), stds("S"))
	, std::make_tuple(stds("THR"), stds("T"))
	, std::make_tuple(stds("TRP"), stds("W"))
	, std::make_tuple(stds("TYR"), stds("Y"))
	, std::make_tuple(stds("VAL"), stds("V")) };
#undef stds	

	for (auto e : l3to1) {
		std::string c1 = mt::MTResidueAA::translate1to3Code(std::get<1>(e));
		BOOST_CHECK_EQUAL( c1, std::get<0>(e) );
	}
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

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

# Test suite: utMTChain
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTChain )
~~~

## Test case: default_factory
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( default_factory )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );
	//BOOST_CHECK_EQUAL( inst, std::dynamic_pointer_cast<mt::MTChain>(inst) );
}
~~~

## Test case: add_remove_residues
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( add_remove_residues )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	BOOST_CHECK_EQUAL( 0, inst->countResidues() );

	mt::MTResidue* r1 = new mt::MTResidue();
	r1->name("r1");
	r1->number(37);
	inst->addResidue(r1);
	BOOST_CHECK_EQUAL( 1, inst->countResidues() );
	inst->addResidue(r1); // can only add a residue once
	BOOST_CHECK_EQUAL( 1, inst->countResidues() );
	auto r2 = inst->getResidue(37);
	std::cerr << bool(r2) << std::endl;
	inst->removeResidue(37);
	BOOST_CHECK_EQUAL( 0, inst->countResidues() );
}
~~~

## Test case: add_remove_heterogens
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( add_remove_heterogens )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	BOOST_CHECK_EQUAL( 0, inst->countHeterogens() );

	mt::MTResidue* r1 =new mt::MTResidue();
	r1->name("r1");
	r1->number(36);
	inst->addHeterogen(r1);
	BOOST_CHECK_EQUAL( 1, inst->countHeterogens() );
	inst->addHeterogen(r1); // can only add a residue once
	BOOST_CHECK_EQUAL( 1, inst->countHeterogens() );
	auto r2 = inst->getHeterogen(36);
	std::cerr << bool(r2) << std::endl;
	inst->removeHeterogen(36);
	BOOST_CHECK_EQUAL( 0, inst->countHeterogens() );
}
~~~

## Test case: add_remove_solvent
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( add_remove_solvent )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	BOOST_CHECK_EQUAL( 0, inst->countSolvent() );

	mt::MTResidue* r1 = new mt::MTResidue();
	r1->name("HOH");
	r1->number(35);
	inst->addSolvent(r1);
	BOOST_CHECK_EQUAL( 1, inst->countSolvent() );
	inst->addSolvent(r1); // can only add a residue once
	BOOST_CHECK_EQUAL( 1, inst->countSolvent() );
	auto r2 = inst->getSolvent(35);
	std::cerr << bool(r2) << std::endl;
	inst->removeSolvent(35);
	BOOST_CHECK_EQUAL( 0, inst->countSolvent() );
}
~~~

## Test case: fmap_over_residues
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( fmap_over_residues )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	BOOST_CHECK_EQUAL( 0, inst->countResidues() );
	int counter=0;
	auto _fmap = [&counter](mt::MTResidue* const & r)->bool {
				++counter; return false; };
	inst->findResidue(_fmap);
	BOOST_CHECK_EQUAL( 0, counter );

	mt::MTResidue* r1=new mt::MTResidue();
	r1->name("r1");
	r1->number(37);
	inst->addResidue(r1);
	BOOST_CHECK_EQUAL( 1, inst->countResidues() );
	counter=0;
	inst->findResidue(_fmap);
	BOOST_CHECK_EQUAL( 1, counter );

	inst->removeResidue(37);
	BOOST_CHECK_EQUAL( 0, inst->countResidues() );
	counter=0;
	inst->findResidue(_fmap);
	BOOST_CHECK_EQUAL( 0, counter );
}
~~~

## Test case: fmap_over_heterogens
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( fmap_over_heterogens )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	BOOST_CHECK_EQUAL( 0, inst->countHeterogens() );
	int counter=0;
	auto _fmap = [&counter](mt::MTResidue* const & r)->bool {
				++counter; return false; };
	inst->findHeterogen(_fmap);
	BOOST_CHECK_EQUAL( 0, counter );

	mt::MTResidue* r1=new mt::MTResidue();
	r1->name("AMP");
	r1->number(38);
	inst->addHeterogen(r1);
	BOOST_CHECK_EQUAL( 1, inst->countHeterogens() );
	counter=0;
	inst->findHeterogen(_fmap);
	BOOST_CHECK_EQUAL( 1, counter );

	inst->removeHeterogen(38);
	BOOST_CHECK_EQUAL( 0, inst->countHeterogens() );
	counter=0;
	inst->findHeterogen(_fmap);
	BOOST_CHECK_EQUAL( 0, counter );
}
~~~

## Test case: fmap_over_solvant
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( fmap_over_solvant )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	BOOST_CHECK_EQUAL( 0, inst->countSolvent() );
	int counter=0;
	auto _fmap = [&counter](mt::MTResidue* const & r)->bool {
				++counter; return false; };
	inst->findSolvent(_fmap);
	BOOST_CHECK_EQUAL( 0, counter );

	mt::MTResidue* r1=new mt::MTResidue();
	r1->name("HOH");
	r1->number(39);
	inst->addSolvent(r1);
	BOOST_CHECK_EQUAL( 1, inst->countSolvent() );
	counter=0;
	inst->findSolvent(_fmap);
	BOOST_CHECK_EQUAL( 1, counter );

	inst->removeSolvent(39);
	BOOST_CHECK_EQUAL( 0, inst->countSolvent() );
	counter=0;
	inst->findSolvent(_fmap);
	BOOST_CHECK_EQUAL( 0, counter );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

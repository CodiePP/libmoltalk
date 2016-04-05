~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTChainFactory.hpp"
#include "MTChain.hpp"
#include "MTResidue.hpp"
#include "MTAtom.hpp"
#include "MTCoordinates.hpp"

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

## Test case: residue_hash_map
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( residue_hash_map )
{
	mt::MTChainFactory _factory;
	auto inst = _factory.newInstance();
	BOOST_CHECK( bool(inst) );

	mt::MTResidue* r1=new mt::MTResidue();
	r1->name("r1"); r1->number(37);
	inst->addResidue(r1);
        mt::MTAtom* a1=new mt::MTAtom();
        a1->setXYZB(1.0, -2.0, 3.0, 97.0);
        r1->addAtom(a1);
	mt::MTResidue* r2=new mt::MTResidue();
	r2->name("r2"); r2->number(38);
	inst->addResidue(r2);
        mt::MTAtom* a2=new mt::MTAtom();
        a2->setXYZB(1.1, -2.1, 3.1, 98.0);
        r2->addAtom(a2);
	mt::MTResidue* r3=new mt::MTResidue();
	r3->name("r3"); r3->number(39);
	inst->addResidue(r3);
        mt::MTAtom* a3=new mt::MTAtom();
        a3->setXYZB(10.1, -12.1, 42.1, 99.0);
        r3->addAtom(a3);

	BOOST_CHECK_EQUAL( 3, inst->countResidues() );

        inst->prepareResidueHash(8);

        mt::MTCoordinates c1(0.9, -2.05, 2.94);
        auto l1 = inst->findResiduesCloseTo(c1);
        std::clog << "|l1| = " << l1.size() << std::endl;
        BOOST_CHECK_EQUAL( 2, l1.size() );
        for (auto r : l1) {
            std::clog << "    r = " << r->name() << " " << r->number() << std::endl; }
        mt::MTCoordinates c2(10.9, -12.05, 42.94);
        auto l2 = inst->findResiduesCloseTo(c2);
        BOOST_CHECK_EQUAL( 1, l2.size() );
        std::clog << "|l2| = " << l2.size() << std::endl;
        for (auto r : l2) {
            std::clog << "    r = " << r->name() << " " << r->number() << std::endl; }
        mt::MTCoordinates c3(-10.9, 12.05, -42.94);
        auto l3 = inst->findResiduesCloseTo(c3);
        BOOST_CHECK_EQUAL( 0, l3.size() );
        std::clog << "|l3| = " << l3.size() << std::endl;
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

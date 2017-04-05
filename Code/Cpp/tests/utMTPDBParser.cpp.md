~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"
#include "boost/chrono/chrono.hpp"
#include "boost/chrono/round.hpp"
#include "boost/chrono/chrono_io.hpp"

#include "MTPDBParser.hpp"
#include "MTStructure.hpp"
#include "MTChain.hpp"
#include "MTResidue.hpp"
#include "MTAtom.hpp"

#include <iostream>
#include <memory>
#include <fstream>

#include "boost/filesystem.hpp"
~~~

# Test suite: utMTPDBParser
~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTPDBParser )
~~~

## Test case: make_integer_number_from_string
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( make_integer_number_from_string )
{
	mt::MTPDBParser _parser;
	BOOST_CHECK_EQUAL( _parser.make_int("33",2), 33 );
	BOOST_CHECK_EQUAL( _parser.make_int("0",1), 0 );
	BOOST_CHECK_EQUAL( _parser.make_int("-42",3), -42 );
}
~~~

## Test case: make_real_number_from_string
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( make_real_number_from_string )
{
	mt::MTPDBParser _parser;
	BOOST_CHECK_EQUAL( _parser.make_float("33.0",4), 33.0 );
	BOOST_CHECK_EQUAL( _parser.make_float("0",1), 0 );
	BOOST_CHECK_EQUAL( _parser.make_float("-42.0",5), -42.0 );
	BOOST_CHECK_EQUAL( _parser.make_float("0.000001",8), 0.000001 );
}
~~~

## Test case: performance_real_number_from_string
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( performance_real_number_from_string )
{
	mt::MTPDBParser _parser;
	auto t0 = boost::chrono::system_clock::now();
	int cnt = 0;
	for (int i=0; i<1e6; i++) {
		if (atof("33.0")==33.0) { ++cnt; } }

	auto t1 = boost::chrono::system_clock::now();
	BOOST_CHECK_EQUAL( 1e6, cnt );
	std::clog << "it took for libc function atof: " << (boost::chrono::round<boost::chrono::milliseconds>(t1 - t0)).count() << " ms" << std::endl;
	t0 = boost::chrono::system_clock::now();
	cnt = 0;
	for (int i=0; i<1e6; i++) {
		if (_parser.make_float("33.0", 4)==33.0) { ++cnt; } }

	t1 = boost::chrono::system_clock::now();
	BOOST_CHECK_EQUAL( 1e6, cnt );
	std::clog << "it took for our internal function mkFloat: " << (boost::chrono::round<boost::chrono::milliseconds>(t1 - t0)).count() << " ms" << std::endl;
}
~~~

## Test case: performance_integer_number_from_string
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( performance_integer_number_from_string )
{
	mt::MTPDBParser _parser;
	auto t0 = boost::chrono::system_clock::now();
	int cnt = 0;
	for (int i=0; i<1e6; i++) {
		if (atoi("33")==33) { ++cnt; } }

	auto t1 = boost::chrono::system_clock::now();
	BOOST_CHECK_EQUAL( 1e6, cnt );
	std::clog << "it took for libc function atoi: " << (boost::chrono::round<boost::chrono::milliseconds>(t1 - t0)).count() << " ms" << std::endl;
	t0 = boost::chrono::system_clock::now();
	cnt = 0;
	for (int i=0; i<1e6; i++) {
		if (_parser.make_int("33", 2)==33) { ++cnt; } }

	t1 = boost::chrono::system_clock::now();
	BOOST_CHECK_EQUAL( 1e6, cnt );
	std::clog << "it took for our internal function mkInt: " << (boost::chrono::round<boost::chrono::milliseconds>(t1 - t0)).count() << " ms" << std::endl;
}
~~~

## Test case: mk_iso_date
~~~ { .cpp }
/*
BOOST_AUTO_TEST_CASE( mk_iso_date )
{
	mt::MTPDBParser _parser;
	std::string d1("04-MAR-78");
	std::string d2("24-JUN-16");

	auto ts1 = _parser.mkISOdate(d1);
	auto ts2 = _parser.mkISOdate(d2);

	std::clog << "d1 = " << d1 << " became " << ts1 << " printed: " << _parser.prtISOdate(ts1) << std::endl;
	std::clog << "d2 = " << d2 << " became " << ts2 << " printed: " << _parser.prtISOdate(ts2) << std::endl;
} */
~~~

## Test case: clip_strings
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( clip_strings )
{
	mt::MTPDBParser _parser;
	std::string r("abcd    "); _parser.clipright(r);
	BOOST_CHECK_EQUAL( "abcd", r );
	std::string l("  abcd"); _parser.clipleft(l);
	BOOST_CHECK_EQUAL( "abcd", l );
	std::string b("  abcd  "); _parser.clip(b);
	BOOST_CHECK_EQUAL( "abcd", b );

	std::string e1; _parser.clipright(e1);
	BOOST_CHECK( e1.empty() );
	std::string e2; _parser.clipleft(e2);
	BOOST_CHECK( e2.empty() );
	std::string e3; _parser.clip(e3);
	BOOST_CHECK( e3.empty() );

	std::string v1(""); _parser.clipright(v1);
	BOOST_CHECK( v1.empty() );
	std::string v2(""); _parser.clipleft(v2);
	BOOST_CHECK( v2.empty() );
	std::string v3(""); _parser.clip(v3);
	BOOST_CHECK( v3.empty() );

	std::string x1("   "); _parser.clipright(x1);
	BOOST_CHECK_EQUAL( "", x1 );
	std::string x2("   "); _parser.clipleft(x2);
	BOOST_CHECK_EQUAL( "", x2 );
	std::string x3("   "); _parser.clip(x3);
	BOOST_CHECK_EQUAL( "", x3 );
}
~~~

## Test case: parse_title
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_title )
{
	const std::string fname("/tmp/parse_title.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "SOME     sasfasfdsafd    asdf 94939 " << std::endl;

	_fout << "TITLE     This is a title ...                     " << std::endl;
	_fout << "SMOTHR  asdflkaslkfaslkdf asfd " << std::endl;
	_fout << "TITLE    2 ... with a continuation.               " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	BOOST_CHECK_EQUAL( "This is a title ... ... with a continuation.", _strx->title() );
}
~~~

## Test case: parse_header
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_header )
{
	const std::string fname("/tmp/parse_header.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "SOME     sasfasfdsafd    asdf 94939 " << std::endl;

	_fout << "HEADER    This is a header ...                    " << std::endl;
	_fout << "SMOTHR  asdflkaslkfaslkdf asfd " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	BOOST_CHECK_EQUAL( "This is a header ...", _strx->header() );
}
~~~

## Test case: parse_keywords
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_keywords )
{
	const std::string fname("/tmp/parse_keywords.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "SOME     sasfasfdsafd    asdf 94939 " << std::endl;

	_fout << "KEYWDS    This is a keyword,                    " << std::endl;
	_fout << "SMOTHR  asdflkaslkfaslkdf asfd " << std::endl;
	_fout << "KEYWDS   2 This is another                        " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	auto const & _kw = _strx->keywords();
	BOOST_CHECK_EQUAL( 2, _kw.size() );
	for( auto const & e : _kw ) {
		std::clog << " keyword : " << e << std::endl;
	}
}
~~~

## Test case: parse_atoms
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_atoms )
{
	const std::string fname("/tmp/parse_atoms.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "SOME     sasfasfdsafd    asdf 94939 " << std::endl;
	_fout << "KEYWDS    This is a keyword,                    " << std::endl;
	_fout << "ATOM    293  N   VAL A4221       4.078   5.009 -10.179  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    294  CA  VAL A4221       4.283   4.339  -8.847  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    295  C   VAL A4221       4.986   2.994  -9.034  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    296  O   VAL A4221       4.662   2.248  -9.935  1.00  0.00           O  " << std::endl;
	_fout << "ATOM    297  CB  VAL A4221       2.912   4.149  -8.217  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    298  CG1 VAL A4221       2.979   3.366  -6.898  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    299  CG2 VAL A4221       2.289   5.527  -7.964  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    300  H   VAL A4221       3.492   4.583 -10.830  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    301  HA  VAL A4221       4.860   4.936  -8.201  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    302  HB  VAL A4221       2.324   3.613  -8.906  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    303 HG11 VAL A4221       3.677   3.837  -6.230  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    304 HG12 VAL A4221       2.001   3.345  -6.438  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    305 HG13 VAL A4221       3.295   2.352  -7.081  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    306 HG21 VAL A4221       2.931   6.099  -7.310  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    307 HG22 VAL A4221       2.176   6.054  -8.900  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    308 HG23 VAL A4221       1.326   5.410  -7.501  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    309  N   LYS A  22       5.931   2.704  -8.158  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    310  CA  LYS A  22       6.730   1.439  -8.279  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    311  C   LYS A  22       7.160   0.964  -6.880  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    312  O   LYS A  22       6.622   1.405  -5.884  1.00  0.00           O  " << std::endl;
	_fout << "ATOM    313  CB  LYS A  22       7.986   1.697  -9.141  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    314  CG  LYS A  22       7.633   2.426 -10.450  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    315  CD  LYS A  22       8.859   2.443 -11.384  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    316  CE  LYS A  22       8.583   3.323 -12.608  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    317  NZ  LYS A  22       7.325   2.913 -13.292  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    318  H   LYS A  22       6.106   3.312  -7.412  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    319  HA  LYS A  22       6.139   0.665  -8.730  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    320  HB2 LYS A  22       8.689   2.292  -8.586  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    321  HB3 LYS A  22       8.448   0.755  -9.377  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    322  HG2 LYS A  22       6.822   1.913 -10.940  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    323  HG3 LYS A  22       7.336   3.441 -10.232  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    324  HD2 LYS A  22       9.717   2.830 -10.852  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    325  HD3 LYS A  22       9.076   1.436 -11.709  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    326  HE2 LYS A  22       8.496   4.353 -12.301  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    327  HE3 LYS A  22       9.404   3.235 -13.304  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    328  HZ1 LYS A  22       6.892   2.118 -12.781  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    329  HZ2 LYS A  22       6.664   3.716 -13.309  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    330  HZ3 LYS A  22       7.540   2.621 -14.266  1.00  0.00           H  " << std::endl;

	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);

	_strx->findChain([](mt::MTChain* const & c)->bool {
		std::clog << "    chain " << c->number() << " n:" << c->name() << " d:" << c->description() << " pdb:" << c->fullPDBCode() << std::endl;
		return false;
	});

	auto  _chain = _strx->getChain('A');
	BOOST_CHECK( bool(_chain) );
	BOOST_CHECK_EQUAL( 2, _chain->countResidues() );

/*	_chain->findResidue([](mt::MTResidue* const & r)->bool {
		std::clog << "    residue " << r->name() << r->number() << "  found." << std::endl;
		return false;
	}); */

	auto _r1 = _chain->getResidue(4221);
	BOOST_CHECK( bool(_r1) );
	BOOST_CHECK_EQUAL( "VAL", _r1->name() );
	BOOST_CHECK_EQUAL( 4221, _r1->number() );
	auto _r2 = _chain->getResidue(22);
	BOOST_CHECK( bool(_r2) );
	BOOST_CHECK_EQUAL( "LYS", _r2->name() );
	BOOST_CHECK_EQUAL( 22, _r2->number() );

	_r1->findAtom([](mt::MTAtom* a)->bool {
		std::clog << "    atom " << a->serial() << " (" << a->number() << ") '" << a->name() << "'  found." << std::endl;
		return false;
	});
	_r2->findAtom([](mt::MTAtom* a)->bool {
		std::clog << "    atom " << a->serial() << " (" << a->number() << ") '" << a->name() << "'  found." << std::endl;
		return false;
	});

	auto _ca1 = _r1->getCA();
	BOOST_CHECK( bool(_ca1) );
	auto _ca2 = _r2->getCA();
	BOOST_CHECK( bool(_ca2) );
	_ca2 = _r2->getAtom(310);
	BOOST_CHECK( bool(_ca2) );
}
~~~

## Test case: parse_crystal_data
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_crystal_data )
{
	const std::string fname("/tmp/parse_crystal.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "SOME     sasfasfdsafd    asdf 94939 from 2cst " << std::endl;
	_fout << "CRYST1   56.400  126.000  124.300  90.00  90.00  90.00 P 21 21 21    8          " << std::endl;
	_fout << "ORIGX1      1.000000  0.000000  0.000000        0.00000                         " << std::endl;
	_fout << "ORIGX2      0.000000  1.000000  0.000000        0.00000                         " << std::endl;
	_fout << "ORIGX3      0.000000  0.000000  1.000000        0.00000                         " << std::endl;
	_fout << "SCALE1      0.017730  0.000000  0.000000        0.00000                         " << std::endl;
	_fout << "SCALE2      0.000000  0.007937  0.000000        0.00000                         " << std::endl;
	_fout << "SCALE3      0.000000  0.000000  0.008045        0.00000                         " << std::endl;
	_fout << "MTRIX1   1  0.937000 -0.349000 -0.030000        6.90700    1                    " << std::endl;
	_fout << "MTRIX2   1 -0.349000 -0.937000  0.000000       29.36800    1                    " << std::endl;
	_fout << "MTRIX3   1 -0.028000  0.011000 -1.000000      103.47000    1                    " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	std::string _spcgrp;
	BOOST_CHECK( _strx->getDescriptor("SPACEGROUP", _spcgrp) );
	BOOST_CHECK_EQUAL( "P 21 21 21" , _spcgrp );

	mt::MTMatrix44 _morig;
	BOOST_CHECK( _strx->getDescriptor("ORIGMATRIX", _morig) );
	std::clog << " morig=" << std::endl << _morig << std::endl;
	mt::MTMatrix44 _mscale;
	BOOST_CHECK( _strx->getDescriptor("SCALEMATRIX", _mscale) );
	std::clog << " mscale=" << std::endl << _mscale << std::endl;
	mt::MTMatrix44 _mncs;
	BOOST_CHECK( _strx->getDescriptor("NCSMATRIX", _mncs) );
	std::clog << " mncs=" << std::endl << _mncs << std::endl;
}
~~~

## Test case: parse_source
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_source )
{
	const std::string fname("/tmp/parse_source.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "COMPND    MOL_ID: 1;                                                            " << std::endl;
	_fout << "COMPND   2 MOLECULE: DNA POLYMERASE BETA;                                       " << std::endl;
	_fout << "COMPND   3 CHAIN: A, B;                                                         " << std::endl;
	_fout << "COMPND   4 EC: 2.7.7.7, 4.2.99.-;                                               " << std::endl;
	_fout << "COMPND   5 ENGINEERED: YES;                                                     " << std::endl;
	_fout << "COMPND   6 MUTATION: YES;                                                       " << std::endl;
	_fout << "COMPND   7 MOL_ID: 2;                                                           " << std::endl;
	_fout << "COMPND   8 MOLECULE: DNA (5'-D(P*GP*TP*CP*GP*G)-3');                            " << std::endl;
	_fout << "COMPND   9 CHAIN: D, C;                                                         " << std::endl;
	_fout << "COMPND  10 ENGINEERED: YES;                                                     " << std::endl;
	_fout << "COMPND  11 MOL_ID: 3;                                                           " << std::endl;
	_fout << "COMPND  12 MOLECULE: DNA (5'-D(*GP*CP*TP*GP*AP*TP*GP*CP*GP*C)-3');              " << std::endl;
	_fout << "COMPND  13 CHAIN: P, G;                                                         " << std::endl;
	_fout << "COMPND  14 ENGINEERED: YES;                                                     " << std::endl;
	_fout << "COMPND  15 MOL_ID: 4;                                                           " << std::endl;
	_fout << "COMPND  16 MOLECULE: DNA (5'-D(*CP*CP*GP*AP*CP*GP*GP*CP*GP*CP*AP*TP*CP*AP*GP*C)-" << std::endl;
	_fout << "COMPND  17 3');                                                                 " << std::endl;
	_fout << "COMPND  18 CHAIN: T, F;                                                         " << std::endl;
	_fout << "COMPND  19 ENGINEERED: YES                                                      " << std::endl;
	_fout << "SOURCE    MOL_ID: 1;                                                            " << std::endl;
	_fout << "SOURCE   2 ORGANISM_SCIENTIFIC: HOMO SAPIENS;                                   " << std::endl;
	_fout << "SOURCE   3 ORGANISM_COMMON: HUMAN;                                              " << std::endl;
	_fout << "SOURCE   4 ORGANISM_TAXID: 9606;                                                " << std::endl;
	_fout << "SOURCE   5 GENE: POLB;                                                          " << std::endl;
	_fout << "SOURCE   6 EXPRESSION_SYSTEM: ESCHERICHIA COLI;                                 " << std::endl;
	_fout << "SOURCE   7 EXPRESSION_SYSTEM_TAXID: 562;                                        " << std::endl;
	_fout << "SOURCE   8 EXPRESSION_SYSTEM_STRAIN: TAP56;                                     " << std::endl;
	_fout << "SOURCE   9 EXPRESSION_SYSTEM_VECTOR_TYPE: PLASMID;                              " << std::endl;
	_fout << "SOURCE  10 EXPRESSION_SYSTEM_PLASMID: PWL11;                                    " << std::endl;
	_fout << "SOURCE  11 MOL_ID: 2;                                                           " << std::endl;
	_fout << "SOURCE  12 SYNTHETIC: YES;                                                      " << std::endl;
	_fout << "SOURCE  13 ORGANISM_SCIENTIFIC: SYNTHETIC CONSTRUCT;                            " << std::endl;
	_fout << "SOURCE  14 ORGANISM_TAXID: 32630;                                               " << std::endl;
	_fout << "SOURCE  15 OTHER_DETAILS: POLYDEOXYRIBONUCLEOTIDE FROM IDT;                     " << std::endl;
	_fout << "SOURCE  16 MOL_ID: 3;                                                           " << std::endl;
	_fout << "SOURCE  17 SYNTHETIC: YES;                                                      " << std::endl;
	_fout << "SOURCE  18 ORGANISM_SCIENTIFIC: SYNTHETIC CONSTRUCT;                            " << std::endl;
	_fout << "SOURCE  19 ORGANISM_TAXID: 32630;                                               " << std::endl;
	_fout << "SOURCE  20 OTHER_DETAILS: POLYDEOXYRIBONUCLEOTIDE FROM IDT;                     " << std::endl;
	_fout << "SOURCE  21 MOL_ID: 4;                                                           " << std::endl;
	_fout << "SOURCE  22 SYNTHETIC: YES;                                                      " << std::endl;
	_fout << "SOURCE  23 ORGANISM_SCIENTIFIC: SYNTHETIC CONSTRUCT;                            " << std::endl;
	_fout << "SOURCE  24 ORGANISM_TAXID: 32630;                                               " << std::endl;
	_fout << "SOURCE  25 OTHER_DETAILS: POLYDEOXYRIBONUCLEOTIDE FROM IDT                      " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	std::string _src;
	auto _ch = _strx->getChain(65);
	BOOST_CHECK( bool(_ch) );
	BOOST_CHECK( _ch->getDescriptor("ORGANISM_COMMON", _src) );
	BOOST_CHECK_EQUAL( "HUMAN", _src );
	BOOST_CHECK_EQUAL( "HOMO SAPIENS" , _ch->source() );
}
~~~

## Test case: parse_compound
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_compound )
{
	const std::string fname("/tmp/parse_compound.pdb");
	std::ofstream _fout;
	_fout.open(fname);
/*
	_fout << "COMPND    MOL_ID: 1;                                                            " << std::endl;
	_fout << "COMPND   2 MOLECULE: ASPARTATE AMINOTRANSFERASE, CYTOPLASMIC;                   " << std::endl;
	_fout << "COMPND   3 CHAIN: A, B, C, D;                                                   " << std::endl;
	_fout << "COMPND   4 FRAGMENT: UNP RESIDUES 14-412;                                       " << std::endl;
	_fout << "COMPND   5 SYNONYM: TRANSAMINASE A, GLUTAMATE OXALOACETATE TRANSAMINASE 1;      " << std::endl;
	_fout << "COMPND   6 EC: 2.6.1.1;                                                         " << std::endl;
	_fout << "COMPND   7 ENGINEERED: YES                                                      " << std::endl;
*/
	_fout << "COMPND    MOL_ID: 1;                                                            " << std::endl;
	_fout << "COMPND   2 MOLECULE: DNA POLYMERASE BETA;                                       " << std::endl;
	_fout << "COMPND   3 CHAIN: A, B;                                                         " << std::endl;
	_fout << "COMPND   4 EC: 2.7.7.7, 4.2.99.-;                                               " << std::endl;
	_fout << "COMPND   5 ENGINEERED: YES;                                                     " << std::endl;
	_fout << "COMPND   6 MUTATION: YES;                                                       " << std::endl;
	_fout << "COMPND   7 MOL_ID: 2;                                                           " << std::endl;
	_fout << "COMPND   8 MOLECULE: DNA (5'-D(P*GP*TP*CP*GP*G)-3');                            " << std::endl;
	_fout << "COMPND   9 CHAIN: D, C;                                                         " << std::endl;
	_fout << "COMPND  10 ENGINEERED: YES;                                                     " << std::endl;
	_fout << "COMPND  11 MOL_ID: 3;                                                           " << std::endl;
	_fout << "COMPND  12 MOLECULE: DNA (5'-D(*GP*CP*TP*GP*AP*TP*GP*CP*GP*C)-3');              " << std::endl;
	_fout << "COMPND  13 CHAIN: P, G;                                                         " << std::endl;
	_fout << "COMPND  14 ENGINEERED: YES;                                                     " << std::endl;
	_fout << "COMPND  15 MOL_ID: 4;                                                           " << std::endl;
	_fout << "COMPND  16 MOLECULE: DNA (5'-D(*CP*CP*GP*AP*CP*GP*GP*CP*GP*CP*AP*TP*CP*AP*GP*C)-" << std::endl;
	_fout << "COMPND  17 3');                                                                 " << std::endl;
	_fout << "COMPND  18 CHAIN: T, F;                                                         " << std::endl;
	_fout << "COMPND  19 ENGINEERED: YES                                                      " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	std::string _cmpnd;
	auto _ch = _strx->getChain('F');
	BOOST_CHECK( bool(_ch) );
	BOOST_CHECK( _ch->getDescriptor("MOLECULE", _cmpnd) );
	std::string s_cmpnd("DNA (5'-D(*CP*CP*GP*AP*CP*GP*GP*CP*GP*CP*AP*TP*CP*AP*GP*C)-");
	BOOST_CHECK_EQUAL( s_cmpnd , _cmpnd );
	BOOST_CHECK_EQUAL( s_cmpnd , _ch->compound() );
}
~~~

## Test case: parse_heteroatom
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_heteroatom )
{
	const std::string fname("/tmp/parse_heteroatom.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "HEADER    HYDROLASE                               02-JUN-13   4L15              " << std::endl;
	_fout << "TITLE     CRYSTAL STRUCTURE OF FIGL-1 AAA DOMAIN                                " << std::endl;
	_fout << "COMPND    MOL_ID: 1;                                                            " << std::endl;
	_fout << "COMPND   2 MOLECULE: FIDGETIN-LIKE PROTEIN 1;                                   " << std::endl;
	_fout << "COMPND   3 CHAIN: A;                                                            " << std::endl;
	_fout << "COMPND   4 FRAGMENT: AAA DOMAIN (UNP RESIDUES 261-594);                         " << std::endl;
	_fout << "COMPND   5 SYNONYM: FIDGETIN HOMOLOG;                                           " << std::endl;
	_fout << "COMPND   6 EC: 3.6.4.-;                                                         " << std::endl;
	_fout << "COMPND   7 ENGINEERED: YES                                                      " << std::endl;
	_fout << "SOURCE    MOL_ID: 1;                                                            " << std::endl;
	_fout << "SOURCE   2 ORGANISM_SCIENTIFIC: CAENORHABDITIS ELEGANS;                         " << std::endl;
	_fout << "SOURCE   3 ORGANISM_COMMON: NEMATODE;                                           " << std::endl;
	_fout << "SOURCE   4 ORGANISM_TAXID: 6239;                                                " << std::endl;
	_fout << "SOURCE   5 GENE: FIGL-1, F32D1.1;                                               " << std::endl;
	_fout << "SOURCE   6 EXPRESSION_SYSTEM: ESCHERICHIA COLI;                                 " << std::endl;
	_fout << "SOURCE   7 EXPRESSION_SYSTEM_TAXID: 562                                         " << std::endl;
	_fout << "HET    TAM  A 601      11                                                       " << std::endl;
	_fout << "HETNAM     TAM TRIS(HYDROXYETHYL)AMINOMETHANE                                   " << std::endl;
	_fout << "FORMUL   2  TAM    C7 H17 N O3                                                  " << std::endl;
	_fout << "HETATM 2326  C   TAM A 601     -31.791 -26.062   4.940  1.00 80.91           C  " << std::endl;
	_fout << "ANISOU 2326  C   TAM A 601     9599  11469   9676    657   -746    -94       C  " << std::endl;
	_fout << "HETATM 2327  C1  TAM A 601     -30.841 -25.756   3.802  1.00 80.97           C  " << std::endl;
	_fout << "ANISOU 2327  C1  TAM A 601     9688  11285   9792    633   -734    -72       C  " << std::endl;
	_fout << "HETATM 2328  C2  TAM A 601     -31.435 -25.205   6.150  1.00 73.63           C  " << std::endl;
	_fout << "ANISOU 2328  C2  TAM A 601     8630  10550   8795    763   -759   -211       C  " << std::endl;
	_fout << "HETATM 2329  C3  TAM A 601     -31.625 -27.506   5.346  1.00 78.22           C  " << std::endl;
	_fout << "ANISOU 2329  C3  TAM A 601     9277  11191   9252    548   -737    -50       C  " << std::endl;
	_fout << "HETATM 2330  C4  TAM A 601     -31.462 -25.987   2.443  1.00 78.79           C  " << std::endl;
	_fout << "ANISOU 2330  C4  TAM A 601     9427  11022   9490    578   -726     24       C  " << std::endl;
	_fout << "HETATM 2331  C5  TAM A 601     -32.628 -24.769   6.972  1.00 66.66           C  " << std::endl;
	_fout << "ANISOU 2331  C5  TAM A 601     7644   9848   7835    846   -774   -250       C  " << std::endl;
	_fout << "HETATM 2332  C6  TAM A 601     -30.465 -27.703   6.291  1.00 73.58           C  " << std::endl;
	_fout << "ANISOU 2332  C6  TAM A 601     8711  10546   8699    555   -736   -110       C  " << std::endl;
	_fout << "HETATM 2333  N   TAM A 601     -33.134 -25.843   4.495  1.00 78.97           N  " << std::endl;
	_fout << "ANISOU 2333  N   TAM A 601     9295  11345   9364    677   -751    -45       N  " << std::endl;
	_fout << "HETATM 2334  O4  TAM A 601     -30.660 -25.314   1.500  1.00 78.75           O  " << std::endl;
	_fout << "ANISOU 2334  O4  TAM A 601     9473  10855   9595    594   -719     35       O  " << std::endl;
	_fout << "HETATM 2335  O5  TAM A 601     -32.426 -23.426   7.344  1.00 56.33           O  " << std::endl;
	_fout << "ANISOU 2335  O5  TAM A 601     6305   8474   6623    969   -784   -357       O  " << std::endl;
	_fout << "HETATM 2336  O6  TAM A 601     -30.238 -29.087   6.424  1.00 72.57           O  " << std::endl;
	_fout << "ANISOU 2336  O6  TAM A 601     8612  10445   8515    448   -723    -46       O  " << std::endl;
	_fout << "HETATM 2337  O   HOH A 701      -2.048 -30.516   6.362  1.00 28.54           O  " << std::endl;
	_fout << "ANISOU 2337  O   HOH A 701     3732   3283   3827    327   -523   -422       O  " << std::endl;
	_fout << "HETATM 2338  O   HOH A 702       4.419 -36.132  13.455  1.00 44.01           O  " << std::endl;
	_fout << "ANISOU 2338  O   HOH A 702     5293   6171   5259    610   -368   -117       O  " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	auto _chain = _strx->getChain('A');
	BOOST_CHECK( bool(_chain) );
	_chain->findHeterogen([](mt::MTResidue* const & r)->bool {
		std::clog << "    heterogen " << r->name() << r->number() << "  found." << std::endl;
		return false;
	});

	auto _tam = _chain->getHeterogen(601);
	BOOST_CHECK( bool(_tam) );
	auto _a1 = _tam->getAtom(2333);
	BOOST_CHECK( bool(_a1) );
	BOOST_CHECK_CLOSE_FRACTION( 78.97, _a1->temperature(), 0.00001 );

	
	_tam->findAtom([](mt::MTAtom* a)->bool {
		std::clog << "    atom " << a->serial() << " '" << a->name() << "'  found." << std::endl;
		return false;
	});
}
~~~

## Test case: parse_models
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_models )
{
	const std::string fname("/tmp/parse_models.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "SOME     sasfasfdsafd    asdf 94939 " << std::endl;
	_fout << "KEYWDS    This is a keyword;                    " << std::endl;
	_fout << "MODEL        1                                                                  " << std::endl;
	_fout << "ATOM    293  N   VAL A4221       4.078   5.009 -10.179  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    294  CA  VAL A4221       4.283   4.339  -8.847  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    295  C   VAL A4221       4.986   2.994  -9.034  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    296  O   VAL A4221       4.662   2.248  -9.935  1.00  0.00           O  " << std::endl;
	_fout << "ATOM    297  CB  VAL A4221       2.912   4.149  -8.217  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    298  CG1 VAL A4221       2.979   3.366  -6.898  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    299  CG2 VAL A4221       2.289   5.527  -7.964  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    300  H   VAL A4221       3.492   4.583 -10.830  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    301  HA  VAL A4221       4.860   4.936  -8.201  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    302  HB  VAL A4221       2.324   3.613  -8.906  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    303 HG11 VAL A4221       3.677   3.837  -6.230  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    304 HG12 VAL A4221       2.001   3.345  -6.438  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    305 HG13 VAL A4221       3.295   2.352  -7.081  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    306 HG21 VAL A4221       2.931   6.099  -7.310  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    307 HG22 VAL A4221       2.176   6.054  -8.900  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    308 HG23 VAL A4221       1.326   5.410  -7.501  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    309  N   LYS A  22       5.931   2.704  -8.158  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    310  CA  LYS A  22       6.730   1.439  -8.279  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    311  C   LYS A  22       7.160   0.964  -6.880  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    312  O   LYS A  22       6.622   1.405  -5.884  1.00  0.00           O  " << std::endl;
	_fout << "ATOM    313  CB  LYS A  22       7.986   1.697  -9.141  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    314  CG  LYS A  22       7.633   2.426 -10.450  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    315  CD  LYS A  22       8.859   2.443 -11.384  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    316  CE  LYS A  22       8.583   3.323 -12.608  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    317  NZ  LYS A  22       7.325   2.913 -13.292  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    318  H   LYS A  22       6.106   3.312  -7.412  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    319  HA  LYS A  22       6.139   0.665  -8.730  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    320  HB2 LYS A  22       8.689   2.292  -8.586  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    321  HB3 LYS A  22       8.448   0.755  -9.377  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    322  HG2 LYS A  22       6.822   1.913 -10.940  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    323  HG3 LYS A  22       7.336   3.441 -10.232  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    324  HD2 LYS A  22       9.717   2.830 -10.852  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    325  HD3 LYS A  22       9.076   1.436 -11.709  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    326  HE2 LYS A  22       8.496   4.353 -12.301  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    327  HE3 LYS A  22       9.404   3.235 -13.304  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    328  HZ1 LYS A  22       6.892   2.118 -12.781  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    329  HZ2 LYS A  22       6.664   3.716 -13.309  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    330  HZ3 LYS A  22       7.540   2.621 -14.266  1.00  0.00           H  " << std::endl;
	_fout << "ENDMDL                                                                          " << std::endl;

	_fout << "MODEL        2                                                                  " << std::endl;
	_fout << "ATOM    293  N   VAL B4221       4.078   5.009 -10.179  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    294  CA  VAL B4221       4.283   4.339  -8.847  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    295  C   VAL B4221       4.986   2.994  -9.034  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    296  O   VAL B4221       4.662   2.248  -9.935  1.00  0.00           O  " << std::endl;
	_fout << "ATOM    297  CB  VAL B4221       2.912   4.149  -8.217  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    298  CG1 VAL B4221       2.979   3.366  -6.898  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    299  CG2 VAL B4221       2.289   5.527  -7.964  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    300  H   VAL B4221       3.492   4.583 -10.830  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    301  HA  VAL B4221       4.860   4.936  -8.201  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    302  HB  VAL B4221       2.324   3.613  -8.906  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    303 HG11 VAL B4221       3.677   3.837  -6.230  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    304 HG12 VAL B4221       2.001   3.345  -6.438  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    305 HG13 VAL B4221       3.295   2.352  -7.081  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    306 HG21 VAL B4221       2.931   6.099  -7.310  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    307 HG22 VAL B4221       2.176   6.054  -8.900  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    308 HG23 VAL B4221       1.326   5.410  -7.501  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    309  N   LYS B  22       5.931   2.704  -8.158  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    310  CA  LYS B  22       6.730   1.439  -8.279  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    311  C   LYS B  22       7.160   0.964  -6.880  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    312  O   LYS B  22       6.622   1.405  -5.884  1.00  0.00           O  " << std::endl;
	_fout << "ATOM    313  CB  LYS B  22       7.986   1.697  -9.141  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    314  CG  LYS B  22       7.633   2.426 -10.450  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    315  CD  LYS B  22       8.859   2.443 -11.384  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    316  CE  LYS B  22       8.583   3.323 -12.608  1.00  0.00           C  " << std::endl;
	_fout << "ATOM    317  NZ  LYS B  22       7.325   2.913 -13.292  1.00  0.00           N  " << std::endl;
	_fout << "ATOM    318  H   LYS B  22       6.106   3.312  -7.412  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    319  HA  LYS B  22       6.139   0.665  -8.730  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    320  HB2 LYS B  22       8.689   2.292  -8.586  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    321  HB3 LYS B  22       8.448   0.755  -9.377  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    322  HG2 LYS B  22       6.822   1.913 -10.940  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    323  HG3 LYS B  22       7.336   3.441 -10.232  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    324  HD2 LYS B  22       9.717   2.830 -10.852  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    325  HD3 LYS B  22       9.076   1.436 -11.709  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    326  HE2 LYS B  22       8.496   4.353 -12.301  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    327  HE3 LYS B  22       9.404   3.235 -13.304  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    328  HZ1 LYS B  22       6.892   2.118 -12.781  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    329  HZ2 LYS B  22       6.664   3.716 -13.309  1.00  0.00           H  " << std::endl;
	_fout << "ATOM    330  HZ3 LYS B  22       7.540   2.621 -14.266  1.00  0.00           H  " << std::endl;
	_fout << "ENDMDL                                                                          " << std::endl;

	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser1(0L);
	auto _strx1 = _parser1.parseStructureFromPDBFile(fname);
	BOOST_CHECK_EQUAL( 1, _strx1->models() );
	auto  _chain = _strx1->getChain('A');
	BOOST_CHECK( bool(_chain) );
	BOOST_CHECK_EQUAL( 2, _chain->countResidues() );

	mt::MTPDBParser _parser2((long)mt::MTPDBParser::parse_options::ALL_NMRMODELS);
	auto _strx2 = _parser2.parseStructureFromPDBFile(fname);
	BOOST_CHECK_EQUAL( 2, _strx2->models() );
	_strx2->switchToModel(1);
	_chain = _strx2->getChain('A');
	BOOST_CHECK( bool(_chain) );
	BOOST_CHECK_EQUAL( 2, _chain->countResidues() );
	_strx2->switchToModel(2);
	_chain = _strx2->getChain('A');
	BOOST_CHECK(!bool(_chain) );
	_chain = _strx2->getChain('B');
	BOOST_CHECK( bool(_chain) );
	BOOST_CHECK_EQUAL( 2, _chain->countResidues() );
}
~~~

## Test case: parse_expdata
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_expdata )
{
	const std::string fname("/tmp/parse_expdata.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "EXPDTA    X-RAY DIFFRACTION                                                    " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	BOOST_CHECK_EQUAL( mt::MTStructure::ExperimentType::XRay, _strx->expdata() );

	_fout.open(fname);
	_fout << "EXPDTA    NMR                                                                  " << std::endl;
	_fout << std::endl;
	_fout.close();
	_strx = _parser.parseStructureFromPDBFile(fname);
	BOOST_CHECK_EQUAL( mt::MTStructure::ExperimentType::NMR, _strx->expdata() );
}
~~~

## Test case: parse_revdate
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_revdate )
{
	const std::string fname("/tmp/parse_revdate.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "REVDAT   2   24-FEB-09 1IM2    1       VERSN                                   " << std::endl;
	_fout << "REVDAT   1   08-AUG-01 1IM2    0                                               " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);

  std::string s;
	long dt;
	BOOST_CHECK( _strx->getDescriptor("REVDAT_1", dt) );
  s = _parser.prtISOdate(dt);
	BOOST_CHECK_EQUAL( "08-AUG-01", s );
	BOOST_CHECK( _strx->getDescriptor("REVDAT_2", dt) );
  s = "";
  s = _parser.prtISOdate(dt);
	BOOST_CHECK_EQUAL( "24-FEB-09", s );
	BOOST_CHECK( _strx->getDescriptor("REVDATE", dt) );
  s = "";
  s = _parser.prtISOdate(dt);
	BOOST_CHECK_EQUAL( "24-FEB-09", s );
}
~~~

## Test case: parse_resolution
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_resolution )
{
	const std::string fname("/tmp/parse_resolution.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "REMARK   2 RESOLUTION.    3.81 ANGSTROMS.                                      " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);

	BOOST_CHECK_EQUAL( 3.81f, _strx->resolution() );
}
~~~

## Test case: parse_remarks
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_remarks )
{
	const std::string fname("/tmp/parse_remarks.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "REMARK   2 RESOLUTION.    3.81 ANGSTROMS.                                       " << std::endl;
	_fout << "REMARK   4 1IM2 COMPLIES WITH FORMAT V. 3.15, 01-DEC-08                         " << std::endl;
	_fout << "REMARK 300                                                                      " << std::endl;
	_fout << "REMARK 300 BIOMOLECULE: 1                                                       " << std::endl;
	_fout << "REMARK 300 SEE REMARK 350 FOR THE AUTHOR PROVIDED AND/OR PROGRAM                " << std::endl;
	_fout << "REMARK 300 GENERATED ASSEMBLY INFORMATION FOR THE STRUCTURE IN                  " << std::endl;
	_fout << "REMARK 300 THIS ENTRY. THE REMARK MAY ALSO PROVIDE INFORMATION ON               " << std::endl;
	_fout << "REMARK 300 BURIED SURFACE AREA.                                                 " << std::endl;
	_fout << "REMARK 300 REMARK: THERE ARE 2 MOLECULES IN THE ASYMETRIC UNIT, BECAUSE OF      " << std::endl;
	_fout << "REMARK 300 TWINNING WE OBSERVE ONLY ONE (REF ENTRY 1G41). THE BIOLOGICAL        " << std::endl;
	_fout << "REMARK 300 STRUCTURE CONSISTS OF HEXAMER WHICH PACKS INTO DODECAMER WITH        " << std::endl;
	_fout << "REMARK 300 622 SYMMETRY.                                                        " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser1;
	auto _strx = _parser1.parseStructureFromPDBFile(fname);

	BOOST_CHECK_EQUAL( 3.81f, _strx->resolution() );

	std::string s;
	BOOST_CHECK(!_strx->getDescriptor("REMARK_2", s) );

	mt::MTPDBParser _parser2((long)mt::MTPDBParser::parse_options::ALL_REMARKS);
	_strx = _parser2.parseStructureFromPDBFile(fname);
	BOOST_CHECK_EQUAL( 3.81f, _strx->resolution() );
	BOOST_CHECK( _strx->getDescriptor("REMARK_2", s) );
	BOOST_CHECK_EQUAL( "RESOLUTION.    3.81 ANGSTROMS.", s );
	BOOST_CHECK( _strx->getDescriptor("REMARK_300", s) );
	BOOST_CHECK_EQUAL( 398, s.size() );
	std::clog << "REMARK_300=" << std::endl << s << std::endl;
}
~~~

## Test case: parse_remark350
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_remark350 )
{
	const std::string fname("/tmp/parse_remark350.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "REMARK 350                                                                      " << std::endl;
	_fout << "REMARK 350 COORDINATES FOR A COMPLETE MULTIMER REPRESENTING THE KNOWN           " << std::endl;
	_fout << "REMARK 350 BIOLOGICALLY SIGNIFICANT OLIGOMERIZATION STATE OF THE                " << std::endl;
	_fout << "REMARK 350 MOLECULE CAN BE GENERATED BY APPLYING BIOMT TRANSFORMATIONS          " << std::endl;
	_fout << "REMARK 350 GIVEN BELOW.  BOTH NON-CRYSTALLOGRAPHIC AND                          " << std::endl;
	_fout << "REMARK 350 CRYSTALLOGRAPHIC OPERATIONS ARE GIVEN.                               " << std::endl;
	_fout << "REMARK 350                                                                      " << std::endl;
	_fout << "REMARK 350 BIOMOLECULE: 1                                                       " << std::endl;
	_fout << "REMARK 350 AUTHOR DETERMINED BIOLOGICAL UNIT: HEXAMERIC                         " << std::endl;
	_fout << "REMARK 350 APPLY THE FOLLOWING TO CHAINS: A                                     " << std::endl;
	_fout << "REMARK 350   BIOMT1   1  1.000000  0.000000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT2   1  0.000000  1.000000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT3   1  0.000000  0.000000  1.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT1   2 -0.500000 -0.866025  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT2   2  0.866025 -0.500000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT3   2  0.000000  0.000000  1.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT1   3 -0.500000  0.866025  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT2   3 -0.866025 -0.500000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT3   3  0.000000  0.000000  1.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT1   4 -1.000000  0.000000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT2   4  0.000000 -1.000000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT3   4  0.000000  0.000000  1.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT1   5  0.500000  0.866025  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT2   5 -0.866025  0.500000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT3   5  0.000000  0.000000  1.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT1   6  0.500000 -0.866025  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT2   6  0.866025  0.500000  0.000000        0.00000            " << std::endl;
	_fout << "REMARK 350   BIOMT3   6  0.000000  0.000000  1.000000        0.00000            " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser1;
	auto _strx = _parser1.parseStructureFromPDBFile(fname);

	mt::MTMatrix53 m;
	BOOST_CHECK( _strx->getDescriptor("BIOMT_5", m) );
	BOOST_CHECK_EQUAL( 0.5, m.atRowCol(0,0) );
	BOOST_CHECK_EQUAL( 0.5, m.atRowCol(1,1) );
	BOOST_CHECK_EQUAL( 1.0, m.atRowCol(2,2) );
	std::clog << "m = " << m << std::endl;

	std::string s;
	BOOST_CHECK(!_strx->getDescriptor("REMARK_350", s) );

	mt::MTPDBParser _parser2((long)mt::MTPDBParser::parse_options::ALL_REMARKS);
	_strx = _parser2.parseStructureFromPDBFile(fname);
	BOOST_CHECK( _strx->getDescriptor("BIOMT_5", m) );
	BOOST_CHECK( _strx->getDescriptor("REMARK_350", s) );
	BOOST_CHECK_EQUAL( 1392, s.size() );
	std::clog << "REMARK_350=" << std::endl << s << std::endl;
}
~~~

## Test case: parse_connect
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_connect )
{
	const std::string fname("/tmp/parse_connect.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "ATOM    444  N   SER A 181      56.426  20.709   7.271  1.00 37.71           N  " << std::endl;
	_fout << "ATOM    445  CA  SER A 181      56.800  20.671   5.866  1.00 41.04           C  " << std::endl;
	_fout << "ATOM    446  C   SER A 181      56.097  21.800   5.112  1.00 45.93           C  " << std::endl;
	_fout << "ATOM    447  O   SER A 181      56.738  22.539   4.368  1.00 46.87           O  " << std::endl;
	_fout << "ATOM    448  CB  SER A 181      56.414  19.331   5.250  1.00 41.90           C  " << std::endl;
	_fout << "ATOM    449  OG  SER A 181      56.962  18.259   5.982  1.00 40.73           O  " << std::endl;
	_fout << "HETATM 2431 MG    MG A 445      56.974  16.191   6.926  1.00 47.67          MG  " << std::endl;
	_fout << "HETATM 2432  PG  ATP A 446      54.842  15.649  10.057  1.00 61.14           P  " << std::endl;
	_fout << "HETATM 2433  O1G ATP A 446      55.121  16.579  11.183  1.00 61.02           O  " << std::endl;
	_fout << "HETATM 2434  O2G ATP A 446      54.417  14.215  10.611  1.00 61.85           O  " << std::endl;
	_fout << "HETATM 2435  O3G ATP A 446      56.143  15.519   9.128  1.00 56.75           O  " << std::endl;
	_fout << "HETATM 2436  PB  ATP A 446      53.904  17.623   8.548  1.00 64.76           P  " << std::endl;
	_fout << "HETATM 2437  O1B ATP A 446      54.000  18.629   9.629  1.00 52.53           O  " << std::endl;
	_fout << "HETATM 2438  O2B ATP A 446      55.196  17.591   7.583  1.00 59.90           O  " << std::endl;
	_fout << "HETATM 2439  O3B ATP A 446      53.622  16.160   9.206  1.00 60.46           O  " << std::endl;
	_fout << "HETATM 2440  PA  ATP A 446      52.532  19.104   6.782  1.00 59.29           P  " << std::endl;
	_fout << "HETATM 2441  O1A ATP A 446      53.619  19.055   5.769  1.00 56.35           O  " << std::endl;
	_fout << "HETATM 2442  O2A ATP A 446      52.563  20.451   7.659  1.00 58.55           O  " << std::endl;
	_fout << "HETATM 2443  O3A ATP A 446      52.589  17.833   7.701  1.00 60.65           O  " << std::endl;
	_fout << "HETATM 2444  O5' ATP A 446      51.118  18.845   6.141  1.00 55.77           O  " << std::endl;
	_fout << "HETATM 2445  C5' ATP A 446      50.784  19.806   5.199  1.00 54.22           C  " << std::endl;
	_fout << "HETATM 2446  C4' ATP A 446      49.406  19.398   4.731  1.00 52.71           C  " << std::endl;
	_fout << "HETATM 2447  O4' ATP A 446      48.449  19.396   5.830  1.00 49.28           O  " << std::endl;
	_fout << "HETATM 2448  C3' ATP A 446      48.907  20.350   3.670  1.00 53.77           C  " << std::endl;
	_fout << "HETATM 2449  O3' ATP A 446      48.493  19.628   2.526  1.00 55.65           O  " << std::endl;
	_fout << "HETATM 2450  C2' ATP A 446      47.764  21.115   4.309  1.00 54.97           C  " << std::endl;
	_fout << "HETATM 2451  O2' ATP A 446      46.572  20.885   3.566  1.00 62.44           O  " << std::endl;
	_fout << "HETATM 2452  C1' ATP A 446      47.638  20.603   5.768  1.00 53.12           C  " << std::endl;
	_fout << "HETATM 2453  N9  ATP A 446      48.125  21.653   6.733  1.00 54.25           N  " << std::endl;
	_fout << "HETATM 2454  C8  ATP A 446      48.851  21.435   7.880  1.00 56.02           C  " << std::endl;
	_fout << "HETATM 2455  N7  ATP A 446      49.116  22.554   8.482  1.00 55.63           N  " << std::endl;
	_fout << "HETATM 2456  C5  ATP A 446      48.578  23.585   7.779  1.00 54.55           C  " << std::endl;
	_fout << "HETATM 2457  C6  ATP A 446      48.540  25.002   7.928  1.00 52.23           C  " << std::endl;
	_fout << "HETATM 2458  N6  ATP A 446      49.151  25.609   9.000  1.00 53.80           N  " << std::endl;
	_fout << "HETATM 2459  N1  ATP A 446      47.898  25.740   7.014  1.00 50.16           N  " << std::endl;
	_fout << "HETATM 2460  C2  ATP A 446      47.302  25.179   5.972  1.00 52.22           C  " << std::endl;
	_fout << "HETATM 2461  N3  ATP A 446      47.315  23.856   5.787  1.00 53.56           N  " << std::endl;
	_fout << "HETATM 2462  C4  ATP A 446      47.930  23.028   6.650  1.00 53.62           C  " << std::endl;
	_fout << "HETATM 2463  O   HOH A 447      58.673  10.502  11.108  1.00 28.12           O  " << std::endl;
	_fout << "HETATM 2464  O   HOH A 448      38.527  31.979   9.395  1.00 40.72           O  " << std::endl;
	_fout << "HETATM 2465  O   HOH A 449      51.795  14.267   7.968  1.00 32.87           O  " << std::endl;
	_fout << "HETATM 2466  O   HOH A 450      38.469  25.697 -10.067  1.00 24.49           O  " << std::endl;
	_fout << "HETATM 2467  O   HOH A 451      48.462  26.932  -3.200  1.00 27.68           O  " << std::endl;
	_fout << "CONECT  449 2431                                                                " << std::endl;
	_fout << "CONECT 2431  449 2435 2438                                                      " << std::endl;
	_fout << "CONECT 2432 2433 2434 2435 2439                                                 " << std::endl;
	_fout << "CONECT 2433 2432                                                                " << std::endl;
	_fout << "CONECT 2434 2432                                                                " << std::endl;
	_fout << "CONECT 2435 2431 2432                                                           " << std::endl;
	_fout << "CONECT 2436 2437 2438 2439 2443                                                 " << std::endl;
	_fout << "CONECT 2437 2436                                                                " << std::endl;
	_fout << "CONECT 2438 2431 2436                                                           " << std::endl;
	_fout << "CONECT 2439 2432 2436                                                           " << std::endl;
	_fout << "CONECT 2440 2441 2442 2443 2444                                                 " << std::endl;
	_fout << "CONECT 2441 2440                                                                " << std::endl;
	_fout << "CONECT 2442 2440                                                                " << std::endl;
	_fout << "CONECT 2443 2436 2440                                                           " << std::endl;
	_fout << "CONECT 2444 2440 2445                                                           " << std::endl;
	_fout << "CONECT 2445 2444 2446                                                           " << std::endl;
	_fout << "CONECT 2446 2445 2447 2448                                                      " << std::endl;
	_fout << "CONECT 2447 2446 2452                                                           " << std::endl;
	_fout << "CONECT 2448 2446 2449 2450                                                      " << std::endl;
	_fout << "CONECT 2449 2448                                                                " << std::endl;
	_fout << "CONECT 2450 2448 2451 2452                                                      " << std::endl;
	_fout << "CONECT 2451 2450                                                                " << std::endl;
	_fout << "CONECT 2452 2447 2450 2453                                                      " << std::endl;
	_fout << "CONECT 2453 2452 2454 2462                                                      " << std::endl;
	_fout << "CONECT 2454 2453 2455                                                           " << std::endl;
	_fout << "CONECT 2455 2454 2456                                                           " << std::endl;
	_fout << "CONECT 2456 2455 2457 2462                                                      " << std::endl;
	_fout << "CONECT 2457 2456 2458 2459                                                      " << std::endl;
	_fout << "CONECT 2458 2457                                                                " << std::endl;
	_fout << "CONECT 2459 2457 2460                                                           " << std::endl;
	_fout << "CONECT 2460 2459 2461                                                           " << std::endl;
	_fout << "CONECT 2461 2460 2462                                                           " << std::endl;
	_fout << "CONECT 2462 2453 2456 2461                                                      " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser1;
	auto _strx = _parser1.parseStructureFromPDBFile(fname);
	BOOST_CHECK( bool(_strx) );
	auto _chain = _strx->getChain('A');
	BOOST_CHECK( bool(_chain) );
	auto _residue = _chain->getResidue(181);
	BOOST_CHECK( bool(_residue) );
	auto _atm1 = _residue->getAtom("OG");
	BOOST_CHECK( _atm1 != nullptr );
	mt::MTAtom * _atm2;
	int _cnt = 0;
	for (auto const a : _atm1->allBondedAtoms()) {
		_cnt++;
		_atm2 = a;
	}
	BOOST_CHECK_EQUAL( 1, _cnt );
	BOOST_CHECK_EQUAL( 2431, _atm2->serial() );
	int _sum = 0;
	_cnt=0; _atm1 = nullptr;
	for (auto const a : _atm2->allBondedAtoms()) {
		_cnt++;
		_sum += a->serial();
		if (a->serial() == 449) { _atm1 = a; }
	}
	BOOST_CHECK_EQUAL( 3, _cnt );
	BOOST_CHECK_EQUAL( 449, _atm1->serial() );
	BOOST_CHECK_EQUAL( 449+2435+2438, _sum );
}
~~~

## Test case: parse_formula
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_formula )
{
	const std::string fname("/tmp/parse_formula.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "FORMUL   1  MSE    9(C5 H11 N O2 SE)                                            " << std::endl;
	_fout << "FORMUL   2  SO4    O4 S 2-                                                      " << std::endl;
	_fout << "FORMUL   3  ADP    C10 H15 N5 O10 P2                                            " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	BOOST_CHECK( bool(_strx) );

	std::string _hform;
	BOOST_CHECK( _strx->getDescriptor("FORMULA_SO4", _hform) );
	BOOST_CHECK_EQUAL( "O4 S 2-" , _hform);
}
~~~

## Test case: parse_hetname
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_hetname )
{
	const std::string fname("/tmp/parse_hetname.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "HETNAM     MSE SELENOMETHIONINE                                                 " << std::endl;
	_fout << "HETNAM     SO4 SULFATE ION                                                      " << std::endl;
	_fout << "HETNAM     ADP ADENOSINE-5'-DIPHOSPHATE                                         " << std::endl;
	_fout << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	BOOST_CHECK( bool(_strx) );

	std::string _hname;
	BOOST_CHECK( _strx->getDescriptor("HETNAME_MSE", _hname) );
	std::clog << " MSE = " << _hname << std::endl;
	BOOST_CHECK( _strx->getDescriptor("HETNAME_ADP", _hname) );
	std::clog << " ADP = " << _hname << std::endl;
	BOOST_CHECK( _strx->getDescriptor("HETNAME_SO4", _hname) );
	std::clog << " SO4 = " << _hname << std::endl;
	BOOST_CHECK_EQUAL( "SULFATE ION" , _hname);
}
~~~

## Test case: parse_modres
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( parse_modres )
{
	const std::string fname("/tmp/parse_modres.pdb");
	std::ofstream _fout;
	_fout.open(fname);
	_fout << "MODRES 1IM2 MSE A    4  MET  SELENOMETHIONINE                                   " << std::endl;
	_fout << "MODRES 1IM2 MSE A   38  MET  SELENOMETHIONINE                                   " << std::endl;
	_fout << "MODRES 1IM2 MSE A   55  MET  SELENOMETHIONINE                                   " << std::endl;
	_fout << "HETATM   16  N   MSE A   4      22.027  39.025  37.282  1.00 29.10           N  " << std::endl;
	_fout << "HETATM   17  CA  MSE A   4      22.938  39.267  36.160  1.00 29.10           C  " << std::endl;
	_fout << "HETATM   18  C   MSE A   4      22.304  40.050  35.016  1.00 29.10           C  " << std::endl;
	_fout << "HETATM   19  O   MSE A   4      21.169  39.775  34.612  1.00 29.10           O  " << std::endl;
	_fout << "HETATM   20  CB  MSE A   4      23.490  37.947  35.622  1.00 29.09           C  " << std::endl;
	_fout << "HETATM   21  CG  MSE A   4      24.921  37.663  36.082  1.00 29.79           C  " << std::endl;
	_fout << "HETATM   22 SE   MSE A   4      25.552  35.919  35.556  1.00 63.77          SE  " << std::endl;
	_fout << "HETATM   23  CE  MSE A   4      26.327  36.376  33.840  1.00 29.79           C  " << std::endl;
	_fout << "HETATM  294  N   MSE A  38       9.821  39.651  37.406  1.00 43.69           N  " << std::endl;
	_fout << "HETATM  295  CA  MSE A  38       9.775  39.549  38.859  1.00 43.69           C  " << std::endl;
	_fout << "HETATM  296  C   MSE A  38       9.516  40.919  39.483  1.00 43.69           C  " << std::endl;
	_fout << "HETATM  297  O   MSE A  38       8.653  41.060  40.346  1.00 43.69           O  " << std::endl;
	_fout << "HETATM  298  CB  MSE A  38      11.101  38.987  39.388  1.00112.89           C  " << std::endl;
	_fout << "HETATM  299  CG  MSE A  38      11.588  37.712  38.691  1.00119.92           C  " << std::endl;
	_fout << "HETATM  300 SE   MSE A  38      10.915  36.016  39.364  1.00100.04          SE  " << std::endl;
	_fout << "HETATM  301  CE  MSE A  38       9.035  36.202  38.918  1.00119.92           C  " << std::endl;
	_fout << "HETATM  436  N   MSE A  55      16.342  29.474  17.395  1.00 24.75           N  " << std::endl;
	_fout << "HETATM  437  CA  MSE A  55      17.678  29.607  16.838  1.00 24.75           C  " << std::endl;
	_fout << "HETATM  438  C   MSE A  55      17.662  28.961  15.480  1.00 24.75           C  " << std::endl;
	_fout << "HETATM  439  O   MSE A  55      17.121  27.879  15.326  1.00 24.75           O  " << std::endl;
	_fout << "HETATM  440  CB  MSE A  55      18.705  28.891  17.703  1.00 12.30           C  " << std::endl;
	_fout << "HETATM  441  CG  MSE A  55      19.010  29.597  18.983  1.00 11.41           C  " << std::endl;
	_fout << "HETATM  442 SE   MSE A  55      20.267  28.560  19.950  1.00 50.66          SE  " << std::endl;
	_fout << "HETATM  443  CE  MSE A  55      20.207  29.551  21.613  1.00 11.41           C  " << std::endl;
	_fout.close();
	mt::MTPDBParser _parser;
	auto _strx = _parser.parseStructureFromPDBFile(fname);
	BOOST_CHECK( bool(_strx) );
	auto _chain = _strx->getChain('A');
	BOOST_CHECK( bool(_chain) );
	auto _residue = _chain->getResidue(4);
	BOOST_CHECK( bool(_residue) );
	BOOST_CHECK_EQUAL( "MSE" , _residue->name() );
	BOOST_CHECK_EQUAL( "MET" , _residue->modname() );
	BOOST_CHECK_EQUAL( "SELENOMETHIONINE" , _residue->moddescription() );
	_residue = _chain->getResidue(38);
	BOOST_CHECK( bool(_residue) );
	BOOST_CHECK_EQUAL( "MSE" , _residue->name() );
	BOOST_CHECK_EQUAL( "MET" , _residue->modname() );
	BOOST_CHECK_EQUAL( "SELENOMETHIONINE" , _residue->moddescription() );
	_residue = _chain->getResidue(55);
	BOOST_CHECK( bool(_residue) );
	BOOST_CHECK_EQUAL( "MSE" , _residue->name() );
	BOOST_CHECK_EQUAL( "MET" , _residue->modname() );
	BOOST_CHECK_EQUAL( "SELENOMETHIONINE" , _residue->moddescription() );
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

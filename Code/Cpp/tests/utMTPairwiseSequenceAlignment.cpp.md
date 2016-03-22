~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTPairwiseSequenceAlignment.hpp"

#include <iostream>
~~~

# Test suite: utMTPairwiseSequenceAlignment

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTPairwiseSequenceAlignment )
~~~

## Test case: global_align_sequence_to_sequence
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( global_align_sequence_to_sequence )
{
	const std::string seq1("ACDEFGHI");
	const std::string seq2("ACDGGGEFGFFFFHI");
	mt::MTPairwiseSequenceAlignment _al(seq1,seq2);
	_al.computeGlobalAlignment();
	std::clog << _al << std::endl;
}
~~~

## Test case: global_align_sequence_to_structure
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( global_align_sequence_to_structure )
{
	//mt::MTPairwiseSequenceAlignment _al(chain1, seq1);
}
~~~

## Test case: global_align_structure_to_structure
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( global_align_structure_to_structure )
{
	//mt::MTPairwiseSequenceAlignment _al(chain1, chain2);
}
~~~

## Test case: local_align_sequence_to_sequence
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( local_align_sequence_to_sequence )
{
	const std::string seq1("ACDEFGHI");
	const std::string seq2("ACDGGGEFGFFFFHI");
	mt::MTPairwiseSequenceAlignment _al(seq1,seq2);
	_al.computeLocalAlignment();
	std::clog << _al << std::endl;
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

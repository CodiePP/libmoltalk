
declared in [MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment.hpp.md)

~~~ { .cpp }
MTPairwiseSequenceAlignment::MTPairwiseSequenceAlignment(MTChain const *c1, MTChain const *c2)
	: MTAlignmentAlgo(c1, c2)
{ }
MTPairwiseSequenceAlignment::MTPairwiseSequenceAlignment(MTChain const *c1, std::string const & s2)
	: MTAlignmentAlgo(c1, s2)
{ }
MTPairwiseSequenceAlignment::MTPairwiseSequenceAlignment(std::string const & s1, std::string const & s2)
	: MTAlignmentAlgo(s1, s2)
{ }
~~~


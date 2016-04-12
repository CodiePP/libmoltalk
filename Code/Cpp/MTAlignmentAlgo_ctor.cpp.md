
declared in [MTAlignmentAlgo](MTAlignmentAlgo.hpp.md)

~~~ { .cpp }
MTAlignmentAlgo::MTAlignmentAlgo(MTChain *c1, MTChain *c2)
{
	_chain1 = c1;
	_chain2 = c2;
        prepare_alignment();
}
MTAlignmentAlgo::MTAlignmentAlgo(MTChain *c1, std::string const & s2)
{
	_chain1 = c1;
	_seq2 = s2;
        prepare_alignment();
}
MTAlignmentAlgo::MTAlignmentAlgo(std::string const & s1, std::string const & s2)
{
	_seq1 = s1;
	_seq2 = s2;
        prepare_alignment();
}
~~~


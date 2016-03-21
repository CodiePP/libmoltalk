
declared in [MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment.hpp.md)

~~~ { .cpp }
MTPairwiseSequenceAlignment::MTPairwiseSequenceAlignment(MTChain const *c1, MTChain const *c2)
	: _pimpl(new pimpl())
{
	_pimpl->_chain1 = c1;
	_pimpl->_chain2 = c2;
}
MTPairwiseSequenceAlignment::MTPairwiseSequenceAlignment(MTChain const *c1, std::string const & s2)
	: _pimpl(new pimpl())
{
	_pimpl->_chain1 = c1;
	_pimpl->_seq2 = s2;
}
MTPairwiseSequenceAlignment::MTPairwiseSequenceAlignment(std::string const & s1, std::string const & s2)
	: _pimpl(new pimpl())
{
	_pimpl->_seq1 = s1;
	_pimpl->_seq2 = s2;
}
~~~


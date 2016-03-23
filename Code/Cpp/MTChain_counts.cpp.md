
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
int MTChain::countResidues() const
{
	return _residues.size();
}

int MTChain::countStandardAminoAcids() const
{
	auto rs = filterResidues([](MTResidue *r)->bool{ r->isStandardAminoAcid(); });
	return rs.size();
}

int MTChain::countHeterogens() const
{
	return _heterogens.size();
}

int MTChain::countSolvent() const
{
	return _solvent.size();
}
~~~


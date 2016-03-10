
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
int MTChain::countResidues() const
{
	return _residues.size();
}

int MTChain::countStandardAminoAcids() const
{
	return 0;
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


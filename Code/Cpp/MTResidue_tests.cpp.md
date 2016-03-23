
declared in [MTResidue](MTResidue.hpp.md)

~~~ { .cpp }

bool MTResidue::isStandardAminoAcid() const
{
	const std::string c1(MTResidueAA::translate3to1Code(name()));
	if (!c1.empty()) { return true; }
	return false;
}

bool MTResidue::isNucleicAcid() const
{
	return false;
}

bool MTResidue::haveAtomsPresent() const
{
	return false;
}

bool MTResidue::isModified() const
{
	return false;
}

~~~


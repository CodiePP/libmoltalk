
declared in [MTResidue](MTResidue.hpp.md)

~~~ { .cpp }

bool MTResidue::isStandardAminoAcid() const
{
	std::string _search = _name;
	if (isModified()) {
		_search = _modname;
	}
	const std::string c1(MTResidueAA::translate3to1Code(_search));
	if (c1 != "X") { return true; }
	return false;
}

bool MTResidue::isNucleicAcid() const
{
	return false;
}

bool MTResidue::hasAtomsPresent() const
{
	return false;
}

bool MTResidue::isModified() const
{
	return _modname.size() > 0;
}

~~~


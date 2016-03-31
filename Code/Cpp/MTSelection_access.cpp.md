
declared in [MTSelection](MTSelection.hpp.md)

~~~ { .cpp }
int MTSelection::count() const
{
        return _residues.size();
}

std::string MTSelection::toString() const
{
	return "";
}

std::list<MTResidue*> MTSelection::getSelection() const
{
	return _residues;
}

~~~


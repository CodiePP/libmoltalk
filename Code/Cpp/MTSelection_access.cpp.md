
declared in [MTSelection](MTSelection.hpp.md)

## MTSelection::count
~~~ { .cpp }
int MTSelection::count() const
{
        return _residues.size();
}
~~~

## MTSelection::toString

TODO :exclamation:

~~~ { .cpp }
std::string MTSelection::toString() const
{
	return "";
}
~~~

## MTSelection::getSelection()
~~~ { .cpp }
std::list<MTResidue*> MTSelection::getSelection() const
{
	return _residues;
}

~~~


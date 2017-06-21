
declared in [MTResidue](MTResidue.hpp.md)

~~~ { .cpp }
int MTResidue::number() const
{
	return _number;
}
void MTResidue::number(int n)
{
	_number = n;
}
char MTResidue::subcode() const
{
	return _subcode;
}
void MTResidue::subcode(char c)
{
	_subcode = c;
}
std::string MTResidue::name() const
{
	return _name;
}
void MTResidue::name(std::string const & n)
{
	_name = n;
}
std::string MTResidue::key() const
{
	return MTResidue::computeKey(_number, _subcode);
}
std::string MTResidue::description() const
{
	return _description;
}

std::string MTResidue::oneLetterCode() const
{
	std::string _search = _name;
	if (isModified()) {
		//std::clog << "oneLetterCode of " << _modname << " (" << _moddesc << ")" << std::endl;
		_search = _modname;
	}
	return MTResidueAA::translate3to1Code(_search);
}

std::string MTResidue::modname() const
{
	return _modname;
}
std::string MTResidue::moddescription() const
{
	return _moddesc;
}
int MTResidue::sequenceNumber() const
{
	return _seqnum;
}
std::string MTResidue::segid() const
{
	return _segid;
}

MTChain* MTResidue::getChain() const
{
	return _chain;
}
~~~


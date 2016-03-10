
declared in [MTPDBParser](MTPDBParser.hpp.md)

~~~ { .cpp }
MTPDBParser::MTPDBParser(long opts)
	: _pimpl(new pimpl)
{
	_pimpl->_options = opts;
}

long MTPDBParser::getOptions() const
{
	return _pimpl->_options;
}

~~~


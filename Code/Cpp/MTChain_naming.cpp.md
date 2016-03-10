
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
char MTChain::code() const
{
	return _code;
}

int MTChain::number() const
{
	return _code;
}

std::string MTChain::name() const
{
	std::string _s;
	if (getDescriptor("_name", _s)) {
		return _s; }
	return (boost::format("%d")%int(_code)).str();
}

std::string MTChain::description() const
{
	std::string _s;
	if (getDescriptor("_description", _s)) {
		return _s; }
	return "";
}

std::string MTChain::fullPDBCode() const
{
	std::string _pdbc("0UNK");
	if (_strx) { _pdbc = _strx->pdbcode(); }
	char buf[32];
	snprintf(buf, 32, "%s%d", _pdbc.c_str(), _code);
	return buf;
}
~~~


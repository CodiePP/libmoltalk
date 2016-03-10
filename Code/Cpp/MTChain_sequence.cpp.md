
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
std::string MTChain::getSEQRES() const
{
	std::string _s;
	if (getDescriptor("SEQRES", _s)) {
		return _s; }
	return "";
}

std::string MTChain::getSequence() const
{
	return "not yet";
}

std::string MTChain::get3DSequence() const
{
	return "not yet";
}
~~~


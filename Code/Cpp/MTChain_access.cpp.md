
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
std::string MTChain::source() const
{
	std::string _s;
	if (getDescriptor("ORGANISM_SCIENTIFIC", _s)) {
		return _s; }
	return "?";
}
std::string MTChain::compound() const
{
	std::string _s;
	if (getDescriptor("MOLECULE", _s)) {
		return _s; }
	return "?";
}
std::string MTChain::eccode() const
{
	std::string _s;
	if (getDescriptor("EC", _s)) {
		return _s; }
	return "?";
}
MTStructure* MTChain::structure() const
{
	return _strx;
}
~~~


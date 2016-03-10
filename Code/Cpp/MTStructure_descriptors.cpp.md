
declared in [MTStructure](MTStructure.hpp.md)

~~~ { .cpp }
bool MTStructure::unsetDescriptor(std::string const & k)
{
	return _descriptors.unset(k);
}

template <typename T>
bool MTStructure::setDescriptor(std::string const & k, T const & v)
{
	return _descriptors.set(k, v);
}
template bool MTStructure::setDescriptor(std::string const & k, int const & v);
template bool MTStructure::setDescriptor(std::string const & k, double const & v);
template bool MTStructure::setDescriptor(std::string const & k, long const & v);
template bool MTStructure::setDescriptor(std::string const & k, MTCoordinates const & v);
template bool MTStructure::setDescriptor(std::string const & k, MTVector const & v);
template bool MTStructure::setDescriptor(std::string const & k, MTMatrix const & v);
template bool MTStructure::setDescriptor(std::string const & k, MTMatrix44 const & v);
template bool MTStructure::setDescriptor(std::string const & k, MTMatrix53 const & v);
template bool MTStructure::setDescriptor(std::string const & k, std::string const & v);

template <typename T>
bool MTStructure::getDescriptor(std::string const & k, T & v) const
{
	return _descriptors.get(k, v);
}
template bool MTStructure::getDescriptor(std::string const & k, int & v) const;
template bool MTStructure::getDescriptor(std::string const & k, double & v) const;
template bool MTStructure::getDescriptor(std::string const & k, long & v) const;
template bool MTStructure::getDescriptor(std::string const & k, MTCoordinates & v) const;
template bool MTStructure::getDescriptor(std::string const & k, MTVector & v) const;
template bool MTStructure::getDescriptor(std::string const & k, MTMatrix & v) const;
template bool MTStructure::getDescriptor(std::string const & k, MTMatrix44 & v) const;
template bool MTStructure::getDescriptor(std::string const & k, MTMatrix53 & v) const;
template bool MTStructure::getDescriptor(std::string const & k, std::string & v) const;

std::list<std::string> MTStructure::allDescriptorKeys() const
{
	std::list<std::string> _res;
	//for (auto const & e : _descriptors) {
	//	_res.push_back(e.first); }
	return _res;
}
~~~



declared in [MTStructure](MTStructure.hpp.md)

~~~ { .cpp }
float MTStructure::resolution() const
{
	return _resolution;
}
std::string MTStructure::pdbcode() const
{
	return _pdbcode;
}
std::string MTStructure::title() const
{
	return _title;
}
std::string MTStructure::header() const
{
	return _header;
}
std::list<std::string> MTStructure::keywords() const
{
	return _keywords;
}

MTStructure::ExperimentType MTStructure::expdata() const
{
	long _t;
	if (_descriptors.get("EXPDATA", _t)) {
		return ExperimentType(_t); }
	return ExperimentType::Unknown;
}

std::ostream & operator<<(std::ostream & o, MTStructure::ExperimentType const & t)
{
	switch (t) {
	case MTStructure::ExperimentType::XRay : 
		o << "XRay"; break;
	case MTStructure::ExperimentType::NMR : 
		o << "NMR"; break;
	case MTStructure::ExperimentType::TheoreticalModel : 
		o << "TheoreticalModel"; break;
	default: 
		o << "Other";
	}
	return o;
}

~~~



declared in [MTDataKV](MTDataKV.hpp.md)

~~~ { .cpp }

template<> bool MTDataKV::_kvpair::get(MTCoordinates & _out) const
{
	if (_t != t_kvpair::MTCoordinates) { return false; }
	_out = *(MTCoordinates*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTVector & _out) const
{
	if (_t != t_kvpair::MTVector) { return false; }
	_out = *(MTVector*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTMatrix & _out) const
{
	if (_t != t_kvpair::MTMatrix) { return false; }
	_out = *(MTMatrix*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTMatrix44 & _out) const
{
	if (_t != t_kvpair::MTMatrix44) { return false; }
	_out = *(MTMatrix44*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTMatrix53 & _out) const
{
	if (_t != t_kvpair::MTMatrix53) { return false; }
	_out = *(MTMatrix53*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(double & _out) const
{
	if (_t != t_kvpair::REAL) { return false; }
	_out = *(double*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(float & _out) const
{
	if (_t != t_kvpair::REAL) { return false; }
	_out = *(double*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(int & _out) const
{
	if (_t != t_kvpair::INT) { return false; }
	_out = *(int64_t*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(long & _out) const
{
	if (_t != t_kvpair::INT) { return false; }
	_out = *(int64_t*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(std::string & _out) const
{
	if (_t != t_kvpair::STR) { return false; }
	_out = *(std::string*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTResidue * & _out) const
{
	if (_t != t_kvpair::MTResidue) { return false; }
	_out = (MTResidue*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTChain * & _out) const
{
	if (_t != t_kvpair::MTChain) { return false; }
	_out = (MTChain*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTStructure * & _out) const
{
	if (_t != t_kvpair::MTStructure) { return false; }
	_out = (MTStructure*)_v;
	return true;
}

template<> bool MTDataKV::_kvpair::get(MTAtom * & _out) const
{
	if (_t != t_kvpair::MTAtom) { return false; }
	_out = (MTAtom*)_v;
	return true;
}


std::string MTDataKV::toString() const
{
        int i=0;
	std::ostringstream ss;
	ss << "[";
	for (auto const & e : _kvmap) {
                if (i>0) { ss << " "; }
		ss << "'" << e.first << "' = " << e.second << std::endl;
                i++;
	}
	ss << "]";
	return ss.str();
}

template <typename T>
bool MTDataKV::get(std::string const & k, T & v) const
{
	auto it = _kvmap.find(k);
	if (it == _kvmap.cend()) { return false; }
	return it->second.get(v);
}
template bool MTDataKV::get(std::string const & k, MTCoordinates & v) const;
template bool MTDataKV::get(std::string const & k, MTVector & v) const;
template bool MTDataKV::get(std::string const & k, MTMatrix & v) const;
template bool MTDataKV::get(std::string const & k, MTMatrix44 & v) const;
template bool MTDataKV::get(std::string const & k, MTMatrix53 & v) const;
template bool MTDataKV::get(std::string const & k, double & v) const;
template bool MTDataKV::get(std::string const & k, float & v) const;
template bool MTDataKV::get(std::string const & k, int & v) const;
template bool MTDataKV::get(std::string const & k, long & v) const;
template bool MTDataKV::get(std::string const & k, std::string & v) const;
template bool MTDataKV::get(std::string const & k, MTResidue * & v) const;
template bool MTDataKV::get(std::string const & k, MTChain * & v) const;
template bool MTDataKV::get(std::string const & k, MTStructure * & v) const;
template bool MTDataKV::get(std::string const & k, MTAtom * & v) const;


template <typename T>
bool MTDataKV::set(std::string const & k, T const & v)
{
	auto it = _kvmap.find(k);
	if (it != _kvmap.cend()) { return false; }
	auto p = _kvmap.emplace(k, v);
	return p.second;
}

template bool MTDataKV::set(std::string const & k, MTCoordinates const & v);
template bool MTDataKV::set(std::string const & k, MTVector const & v);
template bool MTDataKV::set(std::string const & k, MTMatrix const & v);
template bool MTDataKV::set(std::string const & k, MTMatrix44 const & v);
template bool MTDataKV::set(std::string const & k, MTMatrix53 const & v);
template bool MTDataKV::set(std::string const & k, double const & v);
template bool MTDataKV::set(std::string const & k, float const & v);
template bool MTDataKV::set(std::string const & k, int const & v);
template bool MTDataKV::set(std::string const & k, long const & v);
template bool MTDataKV::set(std::string const & k, std::string const & v);
template bool MTDataKV::set(std::string const & k, MTAtom * const & v);
template bool MTDataKV::set(std::string const & k, MTResidue * const & v);
template bool MTDataKV::set(std::string const & k, MTChain * const & v);
template bool MTDataKV::set(std::string const & k, MTStructure * const & v);
bool MTDataKV::set(std::string const & k, char const * v)
{
	return set(k, std::string(v));
}

bool MTDataKV::set(std::string const & k, bool v)
{
	return set(k, int(v));
}

bool MTDataKV::unset(std::string const & k)
{
	auto it = _kvmap.find(k);
	if (it == _kvmap.end()) { return false; }
	_kvmap.erase(it);
	return true;
}

bool MTDataKV::has(std::string const & k) const
{
	auto const it = _kvmap.find(k);
	if (it == _kvmap.cend()) { return false; }
	return true;
}

~~~


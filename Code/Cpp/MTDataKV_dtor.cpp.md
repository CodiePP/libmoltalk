
declared in [MTDataKV](MTDataKV.hpp.md)

~~~ { .cpp }
MTDataKV::~MTDataKV()
{
	_kvmap.clear();
}

MTDataKV::_kvpair::~_kvpair()
{
	//std::clog << "~_kvpair(" << int(_t) << ") : " << *this << std::endl;
        if (_v) { 
		if (_t==t_kvpair::MTVector) { delete (MTVector*)_v; }
		//if (_t==t_kvpair::MTMatrix) { delete (MTMatrix*)_v; }
		//if (_t==t_kvpair::MTMatrix44) { delete (MTMatrix44*)_v; }
		//if (_t==t_kvpair::MTMatrix53) { delete (MTMatrix53*)_v; }
		if (_t==t_kvpair::MTCoordinates) { delete (MTCoordinates*)_v; }
		if (_t==t_kvpair::REAL) { delete (double*)_v; }
		if (_t==t_kvpair::INT) { delete (int64_t*)_v; }
		if (_t==t_kvpair::STR) { delete (std::string*)_v; }
	}
	_v = nullptr;
	_t = t_kvpair::unknown;
}

~~~



declared in [MTDataKV](MTDataKV.hpp.md)

~~~ { .cpp }
MTDataKV::_kvpair::_kvpair(int v)
	: _kvpair(int64_t(v)) 
{ }
MTDataKV::_kvpair::_kvpair(int64_t v)
	: _t(t_kvpair::INT)
{
	_v = new int64_t(v);
}

MTDataKV::_kvpair::_kvpair(float v)
	: _kvpair(double(v)) 
{ }
MTDataKV::_kvpair::_kvpair(double v)
	: _t(t_kvpair::REAL)
{
	_v = new double(v);
}

MTDataKV::_kvpair::_kvpair(std::string const & v)
	: _t(t_kvpair::STR)
{
	_v = new std::string(v);
}

MTDataKV::_kvpair::_kvpair(MTCoordinates const & v)
	: _t(t_kvpair::MTCoordinates)
{
	_v = new MTCoordinates(v);
}

MTDataKV::_kvpair::_kvpair(MTVector const & v)
	: _t(t_kvpair::MTVector)
{
	_v = new MTVector(v);
}

MTDataKV::_kvpair::_kvpair(MTMatrix const & m)
	: _t(t_kvpair::MTMatrix)
{
	_v = new MTMatrix(m);
}

MTDataKV::_kvpair::_kvpair(MTMatrix44 const & m)
	: _t(t_kvpair::MTMatrix44)
{
	_v = new MTMatrix44(m);
}

MTDataKV::_kvpair::_kvpair(MTMatrix53 const & m)
	: _t(t_kvpair::MTMatrix53)
{
	_v = new MTMatrix53(m);
}

MTDataKV::_kvpair::_kvpair(MTAtom * m)
	: _t(t_kvpair::MTAtom)
{
	_v = m;
}

MTDataKV::_kvpair::_kvpair(MTResidue * m)
	: _t(t_kvpair::MTResidue)
{
	_v = m;
}

MTDataKV::_kvpair::_kvpair(MTChain * m)
	: _t(t_kvpair::MTChain)
{
	_v = m;
}

MTDataKV::_kvpair::_kvpair(MTStructure * m)
	: _t(t_kvpair::MTStructure)
{
	_v = m;
}


MTDataKV::MTDataKV()
{ }

~~~


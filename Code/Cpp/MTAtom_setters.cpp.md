
declared in [MTAtom](MTAtom.hpp.md)

~~~ { .cpp }
void MTAtom::setName(std::string const & n)
{
	_name = n;
}
void MTAtom::setSerial(unsigned int n)
{
	_atm_tbl[_number]._serial = n;
}
void MTAtom::setXYZB(double x, double y, double z, double b)
{
	_atm_s & a = _atm_tbl[_number];
	a._x = x;
	a._y = y;
	a._z = z;
	a._temperature = b;
}
void MTAtom::setElement(element_id const & e)
{
	_atm_tbl[_number]._element = e;
}
void MTAtom::setElement(char const s[3])
{
	_atm_s & a = _atm_tbl[_number];
	if (s[0] == 'H') { a._element = element_id::H; return; }
	switch (s[1]) {
	case 'H' : a._element = element_id::H; break;
	case 'C' : a._element = element_id::C; break;
	case 'N' : a._element = element_id::N; break;
	case 'O' : a._element = element_id::O; break;
	case 'P' : a._element = element_id::P; break;
	}
}
void MTAtom::setTemperature(float t)
{
	_atm_tbl[_number]._temperature = t;
}
void MTAtom::setCharge(float c)
{
	_atm_tbl[_number]._charge = c;
}
~~~


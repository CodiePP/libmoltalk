
declared in [MTAtom](MTAtom.hpp.md)

~~~ { .cpp }
std::string MTAtom::name() const
{
	return _name;
}
unsigned int MTAtom::number() const
{
	return _number;
}
unsigned int MTAtom::serial() const
{
	return _atm_tbl[_number]._serial;
}
MTAtom::element_id MTAtom::element() const
{
	return _atm_tbl[_number]._element;
}
std::string MTAtom::elementName() const
{
	return "El";
}
float MTAtom::temperature() const
{
	return _atm_tbl[_number]._temperature;
}
float MTAtom::charge() const
{
	return _atm_tbl[_number]._charge;
}
MTCoordinates MTAtom::coords() const
{
	_atm_s & a = _atm_tbl[_number];
	return MTCoordinates(a._x, a._y, a._z);
}
~~~


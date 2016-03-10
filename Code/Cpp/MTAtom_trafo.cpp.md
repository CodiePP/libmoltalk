
declared in [MTAtom](MTAtom.hpp.md)

~~~ { .cpp }

void MTAtom::transformBy(MTMatrix53 const & c)
{
}

void MTAtom::rotateBy(MTMatrix44 const & c)
{
}

void MTAtom::translateBy(MTCoordinates const & c)
{
	_atm_s & a = _atm_tbl[_number];
	a._x += c.x();
	a._y += c.y();
	a._z += c.z();
}

~~~


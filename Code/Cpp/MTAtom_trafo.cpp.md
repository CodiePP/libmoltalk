
declared in [MTAtom](MTAtom.hpp.md)

~~~ { .cpp }

void MTAtom::transformBy(MTMatrix53 const & tr)
{
	MTMatrix44 r = tr.getRotation();
	MTCoordinates t = tr.getTranslation();
	r.atRowColValue(0,3, t.x());
	r.atRowColValue(1,3, t.y());
	r.atRowColValue(2,3, t.z());
	MTCoordinates o = tr.getOrigin();
	_atm_s & a = _atm_tbl[_number];
	a._x -= o.x();
	a._y -= o.y();
	a._z -= o.z();
	rotateBy(r);
}

/*

[ x0 y0 z0         [ x        [ x'
  x1 y1 z1      x    y     =    y'
  x2 y2 z2           z          z'
  x3 y3 z3 ]         1 ]        _ ]

 */
void MTAtom::rotateBy(MTMatrix44 const & r)
{
	_atm_s & a = _atm_tbl[_number];
	MTMatrix m(4,1);
	m.atRowColValue(0,0, a._x);
	m.atRowColValue(1,0, a._y);
	m.atRowColValue(2,0, a._z);
	m.atRowColValue(3,0, 1.0);
	//std::clog << "m = " << m << std::endl;
	auto m2 = r.x(m);
	//std::clog << "m2 = " << m2 << std::endl;
	a._x = m2.atRowCol(0,0);
	a._y = m2.atRowCol(1,0);
	a._z = m2.atRowCol(2,0);
}

void MTAtom::translateBy(MTCoordinates const & c)
{
	_atm_s & a = _atm_tbl[_number];
	a._x += c.x();
	a._y += c.y();
	a._z += c.z();
}

~~~


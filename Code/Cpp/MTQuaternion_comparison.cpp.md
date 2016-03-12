
declared in [MTQuaternion](MTQuaternion.hpp.md)

>   compare two quaternions

~~~ { .cpp }
bool MTQuaternion::operator==(MTQuaternion const & q2) const
{
	if (x() != q2.x()) { return false; }
	if (y() != q2.y()) { return false; }
	if (z() != q2.z()) { return false; }
	if (w() != q2.w()) { return false; }
	return true;
}
~~~




declared in [MTQuaternion](MTQuaternion.hpp.md)

~~~ { .cpp }
std::string const MTQuaternion::toString() const
{
	std::ostringstream ss;
	ss << "MTQuaternion(";
	ss << _x << ", ";
	ss << _y << ", ";
	ss << _z << ", ";
	ss << _w << ")";
	return ss.str();
}
~~~


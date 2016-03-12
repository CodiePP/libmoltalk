
declared in [MTQuaternion](MTQuaternion.hpp.md)

> calculate magnitude

~~~ { .cpp }
double MTQuaternion::magnitude() const
{
	double m2 = magnitude2();
	if (m2 > 0.0) {
		return sqrt(m2); }
	return 0.0;
}

double MTQuaternion::magnitude2() const
{
	return (_x * _x + _y * _y + _z * _z + _w * _w);
}
~~~


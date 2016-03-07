
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
double MTVector::length() const
{
	double _e;
	double _sum2 = 0.0;
	for (int i=0; i<_dims; i++) {
		_e = _elements[i];
		_sum2 += _e * _e; }
	if (_sum2 > 0.0) {
		return sqrt(_sum2); }
	return 0.0;
}
~~~


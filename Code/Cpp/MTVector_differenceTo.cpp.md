
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
MTVector MTVector::differenceTo(MTVector const & v2) const
{
	int _d = dimensions();
	MTVector _v(_d);
	if (_d == v2.dimensions()) {
		for (int i=0; i<_d; i++) {
			_v.atDim(i, v2.atDim(i) - atDim(i)); }
	}
	return _v;
}
~~~


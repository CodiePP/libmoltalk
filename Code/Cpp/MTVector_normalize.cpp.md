
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
MTVector& MTVector::normalize()
{
	double l = length();
	if (l > 0.0) {
		for (int i = 0; i < dimensions(); i++) {
			atDim(i, atDim(i) / l); }
	}
	return *this;
}
~~~


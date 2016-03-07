
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
double MTVector::euklideanDistanceTo(MTVector const & v2) const
{
	double sum2 = 0.0;
	for (int i=0; i<dimensions(); i++) {
		double e = v2.atDim(i) - atDim(i);
		sum2 += e * e; }
	if (sum2 == 0.0) { return 0.0; }
	return sqrt(sum2);
}
~~~


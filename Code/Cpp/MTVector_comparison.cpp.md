
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
/*
 *   compare two vectors
 */
bool MTVector::operator==(MTVector const & v2) const
{
	int d = v2.dimensions();
	if (dimensions() != d) { return false; }
	for (int i=0; i<d; i++) {
		if (atDim(i) != v2.atDim(i)) {
			return false; } }
	return true;
}
~~~



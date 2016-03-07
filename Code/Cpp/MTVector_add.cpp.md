
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
MTVector& MTVector::add(MTVector const & v2)
{
	if (dimensions() == v2.dimensions()) {
		for (int i=0; i<dimensions(); i++) {
			_elements[i] += v2._elements[i]; } }
	return *this;
}


MTVector& MTVector::operator-=(MTVector const & v2)
{
	if (dimensions() == v2.dimensions()) {
		for (int i=0; i<dimensions(); i++) {
			_elements[i] -= v2._elements[i]; } }
	return *this;
}

MTVector& MTVector::operator+=(MTVector const & v2)
{
	return add(v2);
}

MTVector MTVector::operator-(MTVector const & v2) const
{
	MTVector newv(dimensions());
	if (dimensions() == v2.dimensions()) {
		for (int i=0; i<dimensions(); i++) {
			newv.atDim(i, _elements[i] - v2._elements[i]); } }
	return newv;
}

MTVector MTVector::operator+(MTVector const & v2) const
{
	MTVector newv(dimensions());
	if (dimensions() == v2.dimensions()) {
		for (int i=0; i<dimensions(); i++) {
			newv.atDim(i, _elements[i] + v2._elements[i]); } }
	return newv;
}

~~~

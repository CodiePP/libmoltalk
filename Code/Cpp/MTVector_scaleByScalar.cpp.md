
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
MTVector& MTVector::scaleByScalar(double scalar)
{
	//std::clog << "MTVector::scaleByScalar(s)" << std::endl;
	for (int i=0; i<dimensions(); i++) {
		_elements[i] *= scalar; }
	return *this;
}

MTVector& MTVector::operator*=(double scalar)
{
	//std::clog << "MTVector::operator*=(s)" << std::endl;
	return scaleByScalar(scalar);
}

MTVector MTVector::operator*(double scalar) const
{
	//std::clog << "MTVector::operator*(s)" << std::endl;
	MTVector newv(*this);
	newv.scaleByScalar(scalar);
	return newv;
}
~~~


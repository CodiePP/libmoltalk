
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }

int MTVector::dimensions() const
{
  return _dims;
}

std::string MTVector::toString() const
{
	std::ostringstream ss;
	ss << "[";
	for (int i=0; i<dimensions(); i++) {
		if (i>0) { ss << ", "; }
		ss << atDim(i);
	}
	ss << "]";
	return ss.str();
}

std::string MTVector::description() const
{
  return toString();
}

void MTVector::atDim(int dim, double v)
{
	if (dim >= 0 && dim < _dims) {
		_elements[dim] = v; }
}

double MTVector::atDim(int dim) const
{
	if (dim >= 0 && dim < _dims) {
		return _elements[dim]; }
	return 0.0;
}

~~~


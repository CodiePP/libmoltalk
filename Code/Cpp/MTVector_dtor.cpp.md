
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
MTVector::~MTVector()
{
	if (_elements) { delete[] _elements; }
	_elements = nullptr;
	_dims = -1;
}
~~~


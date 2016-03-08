
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
MTMatrix::~MTMatrix()
{
	if (_elements) {
		delete[] _elements;
		_elements = nullptr;
	}
}
~~~

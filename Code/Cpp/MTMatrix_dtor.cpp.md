
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
MTMatrix::~MTMatrix()
{
    //std::clog << "~MTMatrix(" << _rows << ", " << _cols << ")" << std::endl;
	if (_elements) {
		delete[] _elements;
		_elements = nullptr;
	}
}
~~~

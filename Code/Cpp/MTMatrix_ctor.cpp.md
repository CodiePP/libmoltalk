
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
MTMatrix::MTMatrix(int rows, int cols)
{
    //std::clog << "MTMatrix(" << rows << ", " << cols << ")" << std::endl;
	if (cols > 0 && rows > 0) {
		_rows = rows;
		_cols = cols;
		_elements = new double[_rows * _cols];
		for (int i=0; i<_rows*_cols; i++) {	
			_elements[i] = 0.0; }
	}
}

// make a real copy 
MTMatrix::MTMatrix(MTMatrix const & m)
	: MTMatrix(m._rows,m._cols)
{
    //std::clog << "MTMatrix(MTMatrix(" << m._rows << ", " << m._cols << "))" << std::endl;
	_transposed = m._transposed;
	for (int i=0; i<_rows*_cols; i++) {	
		_elements[i] = m._elements[i]; }
}

MTMatrix & MTMatrix::operator=(MTMatrix const & m)
{
	if (m._cols != _cols || m._rows != _rows) {
		if (_elements) {
			delete[] _elements;
	       		_elements = nullptr; }
		_cols = m._cols; _rows = m._rows;
	}
	if (! _elements) {
		_elements = new double[_rows * _cols];
	}
	_transposed = m._transposed;
	for (int i=0; i<_rows*_cols; i++) {	
		_elements[i] = m._elements[i]; }
}

~~~

deserialize a MTMatrix from its string representation

TODO :exclamation:

~~~ { .cpp }
MTMatrix::MTMatrix(std::string const & str)
{
}
~~~

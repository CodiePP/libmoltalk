
declared in [MTVector](MTVector.hpp.md)

~~~ { .cpp }
MTVector::MTVector(int dim)
  : _dims(dim)
{
    //std::clog << "MTVector::MTVector(" << dim << ")" << std::endl;
    _elements = new double[_dims];
    for (int i=0; i<_dims; i++) {
        _elements[i] = 0.0; }
}

MTVector::MTVector(MTVector const & v)
  : MTVector(v._dims)
{
    //std::clog << "MTVector::MTVector(<copy>)" << std::endl;
    for (int i=0; i<_dims; i++) {
        _elements[i] = v._elements[i]; }
}

MTVector& MTVector::operator=(MTVector const & v)
{
    if (_elements) { delete[] _elements; }
    _dims = v._dims;
    _elements = new double[_dims];
    for (int i=0; i<_dims; i++) {
        _elements[i] = v._elements[i]; }
}

~~~


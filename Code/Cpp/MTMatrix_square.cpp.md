
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
void MTMatrix::square()
{
        double t;
        for (int i=0; i<(_rows*_cols); i++)
        {
                t = _elements[i];
		if (t != 0.0) { _elements[i] = t * t; }
        }
}
~~~


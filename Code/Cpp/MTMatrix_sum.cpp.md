
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
double MTMatrix::sum() const
{
        double res=0.0;
        int num = _rows*_cols;
        int i;
        for (i=0; i<num; i++)
        {
                res += _elements[i];
        }
        return res;
}
~~~


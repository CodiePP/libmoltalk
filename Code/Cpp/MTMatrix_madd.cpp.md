
declared in [MTMatrix](MTMatrix.hpp.md)

>   add a matrix to this and return new result matrix

~~~ { .cpp }
MTMatrix MTMatrix::madd(MTMatrix const & m2) const
{
        int _rows,_cols;
        _rows = m2.rows();
        _cols = m2.cols();
        if ((_rows != rows()) && (_cols != cols()))
        {
                throw "Matrix-madd: needs a matrix with same rows and cols";
        }
        MTMatrix res = MTMatrix(_rows, _cols);
        int icol,irow;
        for (irow=0; irow<_rows; irow++)
        {
                for (icol=0; icol<_cols; icol++)
                {
                        res.atRowColValue(irow, icol, atRowCol(irow, icol) + m2.atRowCol(irow, icol));
                } /* icol */
        } /* irow */
        return res;
}
~~~


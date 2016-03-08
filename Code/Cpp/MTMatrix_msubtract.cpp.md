
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
MTMatrix MTMatrix::msubtract(MTMatrix const & m) const
{
        int row,col;
        row = m.rows();
        col = m.cols();
        if ((row != rows()) && (col != cols()))
        {
                throw "Matrix-msubtract: needs a matrix with same rows and cols";
        }
        MTMatrix res = MTMatrix(row, col);
        int icol,irow;
        for (irow=0; irow<row; irow++)
        {
                for (icol=0; icol<col; icol++)
                {
                        res.atRowColValue(irow, icol, atRowCol(irow, icol) - m.atRowCol(irow, icol));
                } /* icol */
        } /* irow */
        return res;
}
~~~


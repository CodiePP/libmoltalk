
declared in [MTMatrix](MTMatrix.hpp.md)

>   add a matrix to this and return new result matrix

~~~ { .cpp }
MTMatrix MTMatrix::madd(MTMatrix const & m2) const
{
        int row,col;
        row = m2.rows();
        col = m2.cols();
        if ((row != rows()) && (col != cols()))
        {
                throw "Matrix-madd: needs a matrix with same rows and cols";
        }
        MTMatrix res = MTMatrix(row, col);
        int icol,irow;
        for (irow=0; irow<row; irow++)
        {
                for (icol=0; icol<col; icol++)
                {
                        res.atRowColValue(irow, icol, atRowCol(irow, icol) + m2.atRowCol(irow, icol));
                } /* icol */
        } /* irow */
        return res;
}
~~~



declared in [MTMatrix](MTMatrix.hpp.md)

>   pairwise multiplies elements in the matrix and returns result

~~~ { .cpp }
MTMatrix MTMatrix::mmultiply(MTMatrix const & m2) const
{
	int row,col;
	row = m2.rows();
	col = m2.cols();
	if ((row != rows()) && (col != cols()))
	{
		throw "Matrix-mmultiply: needs a matrix with same rows and cols";
	}
	MTMatrix res = MTMatrix(row, col);
	int icol,irow;
	for (irow=0; irow<row; irow++)
	{
		for (icol=0; icol<col; icol++)
		{
			res.atRowColValue(irow, icol, (atRowCol(irow, icol) * m2.atRowCol(irow, icol)));
		} /* icol */
	} /* irow */
	return res;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   pairwise multiplies elements in the matrix and returns result
 */
-(id)mmultiply:(MTMatrix*)m2
{
	int row,col;
	row = [m2 rows];
	col = [m2 cols];
	if ((row != [self rows]) && (col != [self cols]))
	{
		NSLog(@"Matrix-mmultiply: needs a matrix with same rows and cols");
		return nil;
	}
	MTMatrix *res = [MTMatrix matrixWithRows: row cols: col];
	int icol,irow;
	for (irow=0; irow<row; irow++)
	{
		for (icol=0; icol<col; icol++)
		{
			[res atRow: irow col: icol value: ([self atRow: irow col: icol] * [m2 atRow: irow col: icol])];
		} /* icol */
	} /* irow */
	return res;
}
~~~


declared in [MTMatrix](MTMatrix.hpp.md)

>   multiply two matrices and return new result matrix
>   needs matrices: nxk and lxn

~~~ { .cpp }
MTMatrix MTMatrix::x(MTMatrix const & m2) const
{
	int row,col;
	row = m2.rows();
	col = m2.cols();
	if (row != cols())
	{
		throw "Matrix-x: needs a matrix with m2-rows=m1-cols";
	}
	MTMatrix res = MTMatrix( rows(), col );
	int icol,irow;
	int irow2;
	double value;
	for (irow=0; irow<rows(); irow++)
	{
		for (icol=0; icol<col; icol++)
		{
			value = 0.0;
			for (irow2=0; irow2<row; irow2++)
			{
				value += atRowCol(irow, irow2) * m2.atRowCol(irow2, icol);
			}
			res.atRowColValue(irow, icol, value);
		} /* icol */
	} /* irow */
	return res;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   multiply two matrices and return new result matrix
 *   needs matrices: nxk and lxn
 */
-(id)x:(MTMatrix*)m2
{
	int row,col;
	row = [m2 rows];
	col = [m2 cols];
	if (row != [self cols])
	{
		NSLog(@"Matrix-x: needs a matrix with m2-rows=m1-cols");
		return nil;
	}
	MTMatrix *res = [MTMatrix matrixWithRows: [self rows] cols: col];
	int icol,irow;
	int irow2;
	double value;
	for (irow=0; irow<[self rows]; irow++)
	{
		for (icol=0; icol<col; icol++)
		{
			value = 0.0;
			for (irow2=0; irow2<row; irow2++)
			{
				value += [self atRow: irow col: irow2] * [m2 atRow: irow2 col: icol];
			}
			[res atRow: irow col: icol value: value];
		} /* icol */
	} /* irow */
	return res;
}
~~~

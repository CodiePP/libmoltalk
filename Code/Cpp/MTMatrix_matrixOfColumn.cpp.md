
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
MTMatrix MTMatrix::matrixOfColumn(int c) const
{
	auto m = MTMatrix(rows(), 1);
	if (c >= cols()) { return m; }
	for (int r=0; r<rows(); r++) {
		m.atRowColValue(r, 0, atRowCol(r, c));
	}
	return m;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   return a column as a new matrix
 */
-(id)matrixOfColumn:(int)thecol
{
	MTMatrix *res = [MTMatrix matrixWithRows: [self rows] cols: 1];
	int irow;
	for (irow=0; irow<[self rows]; irow++)
	{
		[res atRow: irow col: 0 value: [self atRow: irow col: thecol]];
	}
	return res;
}
~~~

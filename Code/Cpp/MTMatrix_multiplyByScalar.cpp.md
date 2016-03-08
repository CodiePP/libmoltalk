
declared in [MTMatrix](MTMatrix.hpp.md)

>   each element of this matrix is multiplied by the scalar
>   this is done in place! thus overriding all previous values

~~~ { .cpp }
void MTMatrix::multiplyByScalar(double scal)
{
	int icol,irow;
	for (irow=0; irow<rows(); irow++)
	{
		for (icol=0; icol<cols(); icol++)
		{
			atRowColValue(irow, icol, (atRowCol(irow, icol) * scal));
		} /* icol */
	} /* irow */
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   each element of this matrix is multiplied by the scalar
 *   this is done in place! thus overriding all previous values
 */
-(id)multiplyByScalar: (double)scal
{
	int icol,irow;
	for (irow=0; irow<[self rows]; irow++)
	{
		for (icol=0; icol<[self cols]; icol++)
		{
			[self atRow: irow col: icol value: ([self atRow: irow col: icol] * scal)];
		} /* icol */
	} /* irow */
	return self;
}
~~~

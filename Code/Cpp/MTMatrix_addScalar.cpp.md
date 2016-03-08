
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
/*
 *   add a scalar to each element of this matrix
 *   this is done in place! thus overriding all previous values
 */
void MTMatrix::addScalar(double scal)
{
	int n = _rows * _cols;
	for (int i=0; i<n; i++) {
		*(_elements + i) = *(_elements + i) + scal;
	}
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   add a scalar to each element of this matrix
 *   this is done in place! thus overriding all previous values
 */
-(id)addScalar: (double)scal
{
	int icol,irow;
	for (irow=0; irow<[self rows]; irow++)
	{
		for (icol=0; icol<[self cols]; icol++)
		{
			[self atRow: irow col: icol value: ([self atRow: irow col: icol] + scal)];
		} /* icol */
	} /* irow */
	return self;
}
~~~

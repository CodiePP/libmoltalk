
declared in [MTMatrix](MTMatrix.hpp.md)

TODO :exclamation:

~~~ { .cpp }
void MTMatrix::linearizeTo(double *mat, int count) const
{

}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   copy to C array in good order
 */
-(void)linearizeTo:(double*)mat maxElements:(int)count
{
/* OpenGL asks for a matrix in column-major mode, thus m[col][row]
 * 
 *        a0  a4  a8  a12
 *  M = ( a1  a5  a9  a13 )
 *        a2  a6  a10 a14
 *        a3  a7  a11 a15 
 *
 * where a12,a13,a14 is the translation, a0-a10 the 3x3 rotation
 */
 
	int irow,icol;
	for (icol=0; icol<[self cols]; icol++)
	{
		for (irow=0; irow<[self rows]; irow++)
		{
			if (count-- < 0)
			{
				return;
			}
			*mat = [self atRow:irow col:icol];
			mat++;
		}
	}
}
~~~

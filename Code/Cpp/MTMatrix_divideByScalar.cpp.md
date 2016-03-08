
declared in [MTMatrix](MTMatrix.hpp.md)

>  each element of this matrix is divided by the scalar
>  this is done in place! thus overriding all previous values

~~~ { .cpp }
void MTMatrix::divideByScalar(double scal)
{
	if (scal == 0.0) {
		throw "Matrix-divideByScalar: scalar is zero!"; } 
	else {
		multiplyByScalar( 1.0/scal ); }
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   each element of this matrix is divided by the scalar
 *   this is done in place! thus overriding all previous values
 */
-(id)divideByScalar: (double)scal
{
	if (scal == 0.0)
	{
		NSLog(@"Matrix-divideByScalar: scalar is zero!");
		return self;
	}
	return [self multiplyByScalar: (1.0/scal)];
}
~~~

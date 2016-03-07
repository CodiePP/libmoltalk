
declared in [MTVector](MTVector.hpp.md)

##   mixed product between three vectors

~~~ { .cpp }
double MTVector::mixedProductBy(MTVector const & v2, MTVector const & v3)
{
	if (dimensions() < 3 || v2.dimensions() < 3 || v3.dimensions() < 3) {
		return 0.0; }
	MTVector t_v = vectorProductBy(v2);
	MTVector t_v3 = MTVector(3);
	t_v3.atDim(0,v3.atDim(0));
	t_v3.atDim(1,v3.atDim(1));
	t_v3.atDim(2,v3.atDim(2));
	return t_v.scalarProductBy(t_v3);
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   mixed product between three vectors
 */
-(double)mixedProductBy:(MTVector*)v2 and:(MTVector*)v3
{
        if ([self dimension] < 3 || [v2 dimension] < 3 || [v3 dimension] < 3)
        {
                return 0.0;
        }
        MTVector *t_v = [self vectorProductBy:v2];
        MTVector *t_v3 = [MTVector vectorWithDimensions:3];
        [t_v3 atDim:0 value:[v3 atDim:0]];
        [t_v3 atDim:1 value:[v3 atDim:1]];
        [t_v3 atDim:2 value:[v3 atDim:2]];
        return [t_v scalarProductBy: t_v3];
}

~~~

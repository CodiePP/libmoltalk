
declared in [MTVector](MTVector.hpp.md)

##   vector product between two vectors, returned as a new vector

~~~ { .cpp }
MTVector MTVector::vectorProductBy(MTVector const & v2) const
{
        MTVector vprod(4);
        if (dimensions() < 3 || v2.dimensions() < 3)
        {
                return vprod;
        }
        /* only consider first 3 dimensions !!! */
        double a1,a2,a3, b1,b2,b3;
        a1 = atDim(0); a2 = atDim(1); a3 = atDim(2);
        b1 = v2.atDim(0); b2 = v2.atDim(1); b3 = v2.atDim(2);
        vprod.atDim(0, (a2*b3-a3*b2));
        vprod.atDim(1, (a3*b1-a1*b3));
        vprod.atDim(2, (a1*b2-a2*b1));
	vprod.atDim(3, 1.0);
        return vprod;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   vector product between two vectors, returned as a new vector
 */
-(id)vectorProductBy: (MTVector*)v2
{
        if ([self dimension] < 3 || [v2 dimension] < 3)
        {
                return nil;
        }
        /* only consider first 3 dimensions !!! */
        MTVector *vprod = [MTVector vectorWithDimensions:3];
        double a1,a2,a3, b1,b2,b3;
        a1 = [self atDim:0]; a2 = [self atDim:1]; a3 = [self atDim:2];
        b1 = [v2 atDim:0]; b2 = [v2 atDim:1]; b3 = [v2 atDim:2];
        [vprod atDim:0 value: (a2*b3-a3*b2)];
        [vprod atDim:1 value: (a3*b1-a1*b3)];
        [vprod atDim:2 value: (a1*b2-a2*b1)];

        return vprod;
}
~~~

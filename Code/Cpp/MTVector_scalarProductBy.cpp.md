
declared in [MTVector](MTVector.hpp.md)

##   scalar product between two vectors

~~~ { .cpp }
double MTVector::scalarProductBy(MTVector const & v2) const
{
        double sum = 0.0;
        int i;
        for (i=0; i<dimensions(); i++)
        {
                sum += atDim(i) * v2.atDim(i);
        }
        return sum;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   scalar product between two vectors
 */
-(double)scalarProductBy: (MTVector*)v2
{
        if ([self dimension] != [v2 dimension])
        {
                /* raise exception */
                NSLog(@"Vector-scalarProductBy: needs a vector of same length.");
                return -1.0;
        }
        double sum = 0.0;
        int i;
        for (i=0; i<[self dimension]; i++)
        {
                sum += [self atDim: i] * [v2 atDim: i];
        }
        return sum;
}

~~~

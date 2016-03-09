
declared in [MTCoordinates](MTCoordinates.hpp.md)

~~~ { .cpp }
void MTCoordinates::translateBy(MTCoordinates const & v)
{
        if (v.dimensions() < 3)
        {
                // raise exception
                throw "Coordinates-translateBy: needs a vector of length at least 3.";
        }
        atDim(0, x() + v.atDim(0));
        atDim(1, y() + v.atDim(1));
        atDim(2, z() + v.atDim(2));
}
~~~


original objc code:

~~~ { .ObjectiveC }
-(id)translateBy:(MTVector*)v
{
        if ([v dimension] < 3)
        {
                // raise exception
                NSLog(@"Coordinates-translateBy: needs a vector of length at least 3.");
                return nil;
        }
        [self atDim: 0 value: ([self x] + [v atDim: 0])];
        [self atDim: 1 value: ([self y] + [v atDim: 1])];
        [self atDim: 2 value: ([self z] + [v atDim: 2])];
        return self;
}

~~~

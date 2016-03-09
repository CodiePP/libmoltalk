
declared in [MTMatrix53](MTMatrix53.hpp.md)

TODO  :exclamation:

~~~ { .cpp }
void MTMatrix53::invert()
{
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   returns the matrix for an inverse transformation
 */
-(MTMatrix53*)invert
{
        double t;
        t = [self atRow: 0 col: 1];
        [self atRow: 0 col: 1 value: [self atRow: 1 col: 0]];
        [self atRow: 1 col: 0 value: t];
        t = [self atRow: 0 col: 2];
        [self atRow: 0 col: 2 value: [self atRow: 2 col: 0]];
        [self atRow: 2 col: 0 value: t];
        t = [self atRow: 1 col: 2];
        [self atRow: 1 col: 2 value: [self atRow: 2 col: 1]];
        [self atRow: 2 col: 1 value: t];
        t = [self atRow: 3 col: 0];
        [self atRow: 3 col: 0 value: [self atRow: 4 col:0]];
        [self atRow: 4 col: 0 value: t];
        t = [self atRow: 3 col: 1];
        [self atRow: 3 col: 1 value: [self atRow: 4 col:1]];
        [self atRow: 4 col: 1 value: t];
        t = [self atRow: 3 col: 2];
        [self atRow: 3 col: 2 value: [self atRow: 4 col:2]];
        [self atRow: 4 col: 2 value: t];
        return self;
}
~~~

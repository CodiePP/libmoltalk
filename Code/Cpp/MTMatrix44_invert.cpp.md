
declared in [MTMatrix44](MTMatrix44.hpp.md)

~~~ { .cpp }
/*
 *   inverts the matrix
 */
void MTMatrix44::invert()
{
        double t;
        t = atRowCol( 0, 1);
        atRowColValue( 0, 1, atRowCol( 1, 0));
        atRowColValue( 1, 0, t);
        t = atRowCol( 0, 2);
        atRowColValue( 0, 2, atRowCol( 2, 0));
        atRowColValue( 2, 0, t);
        t = atRowCol( 1, 2);
        atRowColValue( 1, 2, atRowCol( 2, 1));
        atRowColValue( 2, 1, t);
        atRowColValue( 3, 0, -atRowCol( 3, 0));
        atRowColValue( 3, 1, -atRowCol( 3, 1));
        atRowColValue( 3, 2, -atRowCol( 3, 2));
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   inverts the matrix
 */
-(MTMatrix44*)invert
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
        [self atRow: 3 col: 0 value: -[self atRow: 3 col: 0]];
        [self atRow: 3 col: 1 value: -[self atRow: 3 col: 1]];
        [self atRow: 3 col: 2 value: -[self atRow: 3 col: 2]];

        return self;
}

~~~

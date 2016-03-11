
declared in [MTMatrix53](MTMatrix53.hpp.md)

~~~ { .cpp }
MTMatrix44 MTMatrix53::getRotation() const
{
	MTMatrix44 m;
	m.atRowColValue(0,0, atRowCol(0,0));
	m.atRowColValue(0,1, atRowCol(0,1));
	m.atRowColValue(0,2, atRowCol(0,2));
	m.atRowColValue(1,0, atRowCol(1,0));
	m.atRowColValue(1,1, atRowCol(1,1));
	m.atRowColValue(1,2, atRowCol(1,2));
	m.atRowColValue(2,0, atRowCol(2,0));
	m.atRowColValue(2,1, atRowCol(2,1));
	m.atRowColValue(2,2, atRowCol(2,2));
	return m;
}

MTCoordinates MTMatrix53::getTranslation() const
{
	return MTCoordinates(atRowCol(4,0), atRowCol(4,1), atRowCol(4,2));
}

MTCoordinates MTMatrix53::getOrigin() const
{
	return MTCoordinates(atRowCol(3,0), atRowCol(3,1), atRowCol(3,2));
}

~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   return rotation matrice
 */
-(MTMatrix44*)getRotation
{
        MTMatrix44 *res = [MTMatrix44 matrixIdentity];
        [res atRow: 0 col: 0 value: [self atRow: 0 col: 0]];
        [res atRow: 0 col: 1 value: [self atRow: 0 col: 1]];
        [res atRow: 0 col: 2 value: [self atRow: 0 col: 2]];
        [res atRow: 1 col: 0 value: [self atRow: 1 col: 0]];
        [res atRow: 1 col: 1 value: [self atRow: 1 col: 1]];
        [res atRow: 1 col: 2 value: [self atRow: 1 col: 2]];
        [res atRow: 2 col: 0 value: [self atRow: 2 col: 0]];
        [res atRow: 2 col: 1 value: [self atRow: 2 col: 1]];
        [res atRow: 2 col: 2 value: [self atRow: 2 col: 2]];
        
        return res;
}

/*
 *   return translation matrice
 */
-(MTMatrix44*)getTranslation
{
        MTMatrix44 *res = [MTMatrix44 matrixIdentity];
        [res atRow: 3 col: 0 value: [self atRow: 4 col: 0]];
        [res atRow: 3 col: 1 value: [self atRow: 4 col: 1]];
        [res atRow: 3 col: 2 value: [self atRow: 4 col: 2]];
        return res;
}


/*
 *   return reset-to-origin vector
 */
-(MTCoordinates*)getOrigin
{
        MTCoordinates *res = [MTCoordinates new];
        [res atDim: 0 value: [self atRow: 3 col: 0]];
        [res atDim: 1 value: [self atRow: 3 col: 1]];
        [res atDim: 2 value: [self atRow: 3 col: 2]];
        [res atDim: 3 value: 0.0];
        return AUTORELEASE(res);
}
~~~


declared in [MTMatrix44](MTMatrix44.hpp.md)

~~~ { .cpp }
/*
 *   creates rotation matrix around X axis
 */
MTMatrix44 MTMatrix44::rotationX(double phi)
{
	MTMatrix44 res;
	double rad = M_PI * phi / 180.0;
	double cosalpha = cos(rad);
	double sinalpha = sin(rad);
	res.atRowColValue(1, 1, cosalpha);
	res.atRowColValue(1, 2, sinalpha);
	res.atRowColValue(2, 1, -sinalpha);
	res.atRowColValue(2, 2, cosalpha);
	return res;
}
~~~

~~~ { .cpp }
MTMatrix44 MTMatrix44::rotationY(double phi)
{
	MTMatrix44 res;
	double rad = M_PI * phi / 180.0;
	double cosalpha = cos(rad);
	double sinalpha = sin(rad);
	res.atRowColValue(0, 0, cosalpha);
	res.atRowColValue(2, 0, sinalpha);
	res.atRowColValue(0, 2, -sinalpha);
	res.atRowColValue(2, 2, cosalpha);
	return res;
}
~~~

~~~ { .cpp }
MTMatrix44 MTMatrix44::rotationZ(double phi)
{
	MTMatrix44 res;
	double rad = M_PI * phi / 180.0;
	double cosalpha = cos(rad);
	double sinalpha = sin(rad);
	res.atRowColValue(0, 0, cosalpha);
	res.atRowColValue(0, 1, sinalpha);
	res.atRowColValue(1, 0, -sinalpha);
	res.atRowColValue(1, 1, cosalpha);
	return res;
}
~~~

~~~ { .cpp }
MTMatrix44 MTMatrix44::rotation(double phi, MTCoordinates const & axis)
{
	double rot = phi * M_PI / 180.0;
	MTMatrix44 res;
	double c = cos(phi);
	double s = sin(phi);
	double t = 1-c;
	double x = axis.x();
	double y = axis.y();
	double z = axis.z();
	res.atRowColValue(0, 0, (t*x*x+c));
	res.atRowColValue(0, 1, (t*x*y+s*z));
	res.atRowColValue(0, 2, (t*x*z-s*y));
	res.atRowColValue(1, 0, (t*x*y-s*z));
	res.atRowColValue(1, 1, (t*y*y+c));
	res.atRowColValue(1, 2, (t*y*z+s*x));
	res.atRowColValue(2, 0, (t*x*z+s*y));
	res.atRowColValue(2, 1, (t*y*z-s*x));
	res.atRowColValue(2, 2, (t*z*z+c));
	res.atRowColValue(3, 3, 1.0);
	return res;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   create rotation matrix around X axis
 */
+(MTMatrix44*)rotationX:(double)alpha
{
	MTMatrix44 *res = [MTMatrix44 new];
	double rad = M_PI * alpha / 180.0;
	double cosalpha = cos(rad);
	double sinalpha = sin(rad);
	[res atRow: 1 col: 1 value: cosalpha];
	[res atRow: 1 col: 2 value: sinalpha];
	[res atRow: 2 col: 1 value: -sinalpha];
	[res atRow: 2 col: 2 value: cosalpha];
	return AUTORELEASE(res);
}

/*
 *   create rotation matrix around Y axis
 */
+(MTMatrix44*)rotationY:(double)alpha
{
	MTMatrix44 *res = [MTMatrix44 new];
	double rad = M_PI * alpha / 180.0;
	double cosalpha = cos(rad);
	double sinalpha = sin(rad);
	[res atRow: 0 col: 0 value: cosalpha];
	[res atRow: 0 col: 2 value: -sinalpha];
	[res atRow: 2 col: 0 value: sinalpha];
	[res atRow: 2 col: 2 value: cosalpha];
	return AUTORELEASE(res);
}

/*
 *   create rotation matrix around Z axis
 */
+(MTMatrix44*)rotationZ:(double)alpha
{
	MTMatrix44 *res = [MTMatrix44 new];
	double rad = M_PI * alpha / 180.0;
	double cosalpha = cos(rad);
	double sinalpha = sin(rad);
	[res atRow: 0 col: 0 value: cosalpha];
	[res atRow: 0 col: 1 value: sinalpha];
	[res atRow: 1 col: 0 value: -sinalpha];
	[res atRow: 1 col: 1 value: cosalpha];
	return AUTORELEASE(res);
}


/*
 *   rotation of an angle (degrees) around an axis
 */
+(MTMatrix44*)rotation: (double)phi aroundAxis:(MTCoordinates*)ax
{
	double rot = phi * M_PI / 180.0;
	MTMatrix44 *res = [MTMatrix44 new];
	double c = cos(rot);
	double s = sin(rot);
	double t = 1-c;
	double x = [ax x];
	double y = [ax y];
	double z = [ax z];
	[res atRow: 0 col: 0 value: (t*x*x+c)];
	[res atRow: 0 col: 1 value: (t*x*y+s*z)];
	[res atRow: 0 col: 2 value: (t*x*z-s*y)];
	[res atRow: 1 col: 0 value: (t*x*y-s*z)];
	[res atRow: 1 col: 1 value: (t*y*y+c)];
	[res atRow: 1 col: 2 value: (t*y*z+s*x)];
	[res atRow: 2 col: 0 value: (t*x*z+s*y)];
	[res atRow: 2 col: 1 value: (t*y*z-s*x)];
	[res atRow: 2 col: 2 value: (t*z*z+c)];
	[res atRow: 3 col: 3 value: 1.0];
	return AUTORELEASE(res);
}
~~~

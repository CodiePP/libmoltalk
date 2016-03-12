
declared in [MTQuaternion](MTQuaternion.hpp.md)

>   return rotation matrix

~~~ { .cpp }
MTMatrix44 MTQuaternion::rotationMatrix() const
{
	MTMatrix44 res;
	double x2,y2,z2;
	x2 = _x * _x; y2 = _y * _y; z2 = _z * _z;
	res.atRowColValue(0, 0, (1.0 - (2.0 * (y2 + z2))));
	res.atRowColValue(1, 0, (2.0 * ((_x * _y) + (_z * _w))));
	res.atRowColValue(2, 0, (2.0 * ((_x * _z) - (_y * _w))));
	res.atRowColValue(0, 1, (2.0 * ((_x * _y) - (_z * _w))));
	res.atRowColValue(1, 1, (1.0 - (2.0 * (x2 + z2))));
	res.atRowColValue(2, 1, (2.0 * ((_y * _z) + (_x * _w))));
	res.atRowColValue(0, 2, (2.0 * ((_x * _z) + (_y * _w))));
	res.atRowColValue(1, 2, (2.0 * ((_y * _z) - (_x * _w))));
	res.atRowColValue(2, 2, (1.0 - (2.0 * (x2 + y2))));
	return res;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   return rotation matrix
 */
-(MTMatrix44*)rotationMatrix;
{
	MTMatrix44 *res = [MTMatrix44 matrixIdentity];
	[res atRow: 0 col: 0 value:  (1.0 - (2.0 * ((y * y) + (z * z))))];
	[res atRow: 1 col: 0 value: (2.0 * ((x * y) + (z * w)))];
	[res atRow: 2 col: 0 value: (2.0 * ((x * z) - (y * w)))];
	[res atRow: 0 col: 1 value: (2.0 * ((x * y) - (z * w)))];
	[res atRow: 1 col: 1 value: (1.0 - (2.0 * ((x * x) + (z * z))))];
	[res atRow: 2 col: 1 value: (2.0 * ((y * z) + (x * w)))];
	[res atRow: 0 col: 2 value: (2.0 * ((x * z) + (y * w)))];
	[res atRow: 1 col: 2 value: (2.0 * ((y * z) - (x * w)))];
	[res atRow: 2 col: 2 value: (1.0 - (2.0 * ((x * x) + (y * y))))];
	return res;
}
~~~

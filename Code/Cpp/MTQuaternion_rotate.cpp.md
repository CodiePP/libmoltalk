
declared in [MTQuaternion](MTQuaternion.hpp.md)

>   combine this quaternion with a rotation

~~~ { .cpp }
MTQuaternion& MTQuaternion::rotate(double phi)
{
	MTQuaternion q2 = MTQuaternion(phi, MTCoordinates(_x, _y, _z));
	return multiplyWith(q2);
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   combine this quaternion with a rotation
 */
-(id)rotate:(double)phi;
{
	MTQuaternion *q2 = [MTQuaternion rotation: phi aroundAxis: [MTCoordinates coordsWithX: x Y: y Z: z]];
	[self multiplyWith: q2];
	return self;
}
~~~

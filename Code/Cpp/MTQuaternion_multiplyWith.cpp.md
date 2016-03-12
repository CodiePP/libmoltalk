
declared in [MTQuaternion](MTQuaternion.hpp.md)

>   product between two quaternions

~~~ { .cpp }
MTQuaternion& MTQuaternion::multiplyWith(MTQuaternion const & q2)
{
	double x2,y2,z2,w2;
	double x3,y3,z3,w3;
	x2 = q2.x(); y2 = q2.y(); z2 = q2.z(); w2 = q2.w();
	x3 = (_w*x2 + _x*w2 + _y*z2 - _z*y2);
	y3 = (_w*y2 - _x*z2 + _y*w2 + _z*x2);
	z3 = (_w*z2 + _x*y2 - _y*x2 + _z*w2);
	w3 = (_w*w2 - _x*x2 - _y*y2 - _z*z2);
	_x = x3; _y = y3; _z = z3; _w = w3;
	return *this;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   product between two quaternions
 */
-(id)multiplyWith: (MTQuaternion*)q2
{
	double x2,y2,z2,w2;
	x2 = [q2 x]; y2 = [q2 y]; z2 = [q2 z]; w2 = [q2 w];
	x = (w*x2 + x*w2 + y*z2 - z*y2);
	y = (w*y2 - x*z2 + y*w2 + z*x2);
	z = (w*z2 + x*y2 - y*x2 + z*w2);
	w = (w*w2 - x*x2 - y*y2 - z*z2);
	return self;
}
~~~

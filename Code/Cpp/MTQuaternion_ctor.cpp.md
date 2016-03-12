
declared in [MTQuaternion](MTQuaternion.hpp.md)

~~~ { .cpp }
MTQuaternion::MTQuaternion()
	: _x(0.0),_y(0.0),_z(0.0),_w(1.0)
{ }

MTQuaternion::MTQuaternion(double p_x, double p_y, double p_z, double p_w)
	: _x(p_x),_y(p_y),_z(p_z),_w(p_w)
{ }
~~~

Define the quaternion by a rotation of angle phi around an axis
~~~ { .cpp }
MTQuaternion::MTQuaternion(double phi, MTCoordinates const & axis)
{
	double a = phi * M_PI / 180.0 / 2.0;
	double sina = sin(a);
	_w = cos(a);
	_x = axis.x() * sina;
	_y = axis.y() * sina;
	_z = axis.z() * sina;
}
~~~


original objc code:

~~~ { .ObjectiveC }
+(MTQuaternion*)rotation:(double)phi aroundAxis:(MTCoordinates*)axis
{
	MTQuaternion *q = [MTQuaternion identity];
	double a = phi * M_PI / 180.0 / 2.0;
	//double a = phi / 2.0;
	double sina = sin(a);
	q->w = cos(a);
	q->x = [axis x] * sina;
	q->y = [axis y] * sina;
	q->z = [axis z] * sina;
	return q;
}
~~~

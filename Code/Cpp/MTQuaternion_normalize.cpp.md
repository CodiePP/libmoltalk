
declared in [MTQuaternion](MTQuaternion.hpp.md)

>   normalize

~~~ { .cpp }
MTQuaternion& MTQuaternion::normalize()
{
	double mag2 = magnitude2();
	if (mag2 <= 0.0) { return *this; }
	double mag=sqrt(mag2);
	_x /= mag;
	_y /= mag;
	_z /= mag;
	_w /= mag;
	return *this;
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   normalize
 */
-(id)normalize
{
	double magnitude=sqrt(x * x + y * y + z * z + w * w);
	x = x / magnitude;
	y = y / magnitude;
	z = z / magnitude;
	w = w / magnitude;
	return self;
}
~~~

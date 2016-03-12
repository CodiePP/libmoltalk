
declared in [MTQuaternion](MTQuaternion.hpp.md)

~~~ { .cpp }
/*
 *   return the inverted quaternion
 */
MTQuaternion MTQuaternion::invert() const
{
	MTQuaternion res; // = [MTQuaternion identity];
	double mag = (1.0 - magnitude2());
	res._x = _x - mag;
	res._y = _y - mag;
	res._z = _z - mag;
	res._w = mag;
	return res.normalize();
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   return the inverted quaternion
 */
-(MTQuaternion*)invert;
{
	MTQuaternion *res = [MTQuaternion identity];
	double len = (1.0 - (x*x + y*y + z*z + w*w));
	res->x = x - len;
	res->y = y - len;
	res->z = z - len;
	res->w = len;
	return res;
}
~~~

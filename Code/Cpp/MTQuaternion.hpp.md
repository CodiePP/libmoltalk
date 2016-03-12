~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTMatrix44.hpp"
#include "MTCoordinates.hpp"

~~~

namespace [mt](namespace_mt.list) {

# class MTQuaternion

>//   class Quaternion represents a quaternion (x,y,z,w)

~~~ { .cpp }
{
private:
        double _x, _y, _z, _w;

public:
~~~

## /* access */

>std::string const [toString](MTQuaternion_toString.cpp.md)() const;

>double x() const { return _x; }

>double y() const { return _y; }

>double z() const { return _z; }

>double w() const { return _w; }

>double [magnitude2](MTQuaternion_magnitude.cpp.md)() const;

>double [magnitude](MTQuaternion_magnitude.cpp.md)() const;

>MTMatrix44 [rotationMatrix](MTQuaternion_rotationMatrix.cpp.md)() const;

>MTQuaternion [invert](MTQuaternion_invert.cpp.md)() const;

## /* comparison */

>bool [operator==](MTQuaternion_comparison.cpp.md)(MTQuaternion const &) const;

## /* operation */

>MTQuaternion& [normalize](MTQuaternion_normalize.cpp.md)();

>MTQuaternion& [rotate](MTQuaternion_rotate.cpp.md)(double phi);

>MTQuaternion& [multiplyWith](MTQuaternion_multiplyWith.cpp.md)(MTQuaternion const & q2);

## /* creation */

>[MTQuaternion](MTQuaternion_ctor.cpp.md)();

>[MTQuaternion](MTQuaternion_ctor.cpp.md)(double x, double y, double z, double w);

>[MTQuaternion](MTQuaternion_ctor.cpp.md)(double phi, MTCoordinates const & axis);

>virtual [~MTQuaternion](MTQuaternion_dtor.cpp.md)();

## /* brewery */

>//[code header](MTQuaternion_-alpha-.md)();

>//[code trailer](MTQuaternion_-omega-.md)();


~~~ { .cpp }
};

std::ostream & operator<<(std::ostream & o, MTQuaternion const & q);

} // namespace
~~~

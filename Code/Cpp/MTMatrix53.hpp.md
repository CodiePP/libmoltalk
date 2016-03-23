~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTMatrix.hpp"

~~~
namespace [mt](namespace_mt.list) {

class MTMatrix44;
class MTCoordinates;

# class MTMatrix53 : public [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
{
public:
~~~

## /* manipulation */

>virtual void [invert](MTMatrix53_invert.cpp)() final;

## /* getter */

>virtual [MTMatrix44](MTMatrix44.hpp.md) [getRotation](MTMatrix53_getter.cpp.md)() const;

>virtual [MTCoordinates](MTCoordinates.hpp.md) [getTranslation](MTMatrix53_getter.cpp.md)() const;

>virtual [MTCoordinates](MTCoordinates.hpp.md) [getOrigin](MTMatrix53_getter.cpp.md)() const;

## /* creation */

>[MTMatrix53](MTMatrix53_ctor.cpp.md)(std::string const & m);

>[MTMatrix53](MTMatrix53_ctor.cpp.md)();

>virtual [~MTMatrix53](MTMatrix53_dtor.cpp.md)();

>static MTMatrix53 [transformation3By3](MTMatrix53_transformation3By3.cpp.md)([MTMatrix](MTMatrix.hpp.md) const & first, [MTMatrix](MTMatrix.hpp.md) const & second);

>static MTMatrix53 [withRotation](MTMatrix53_withRotation.cpp.md)([MTMatrix44](MTMatrix44.hpp.md) const & rot, [MTCoordinates](MTCoordinates.hpp.md) const & origin, [MTCoordinates](MTCoordinates.hpp.md) const & translation);

## /* brewery */

>//[code header](MTMatrix53_-alpha-.md)();

>//[code trailer](MTMatrix53_-omega-.md)();

~~~ { .cpp }
};

} // namespace
~~~


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

class MTCoordinates;

# class MTMatrix44 : public [MTMatrix](MTMatrix.hpp.md)

    {
    public:

## /* manipulation */

>virtual void [invert](MTMatrix44_invert.cpp.md)();

>virtual void [xIP](MTMatrix44_xIP.cpp.md)(MTMatrix44 const & p_mat);

>virtual void [chainWith](MTMatrix44_chainWith.cpp.md)(MTMatrix44 const & p_mat);

## /* creation */

>static MTMatrix44 [rotationX](MTMatrix44_rotation.cpp.md)(double alpha);

>static MTMatrix44 [rotationY](MTMatrix44_rotation.cpp.md)(double alpha);

>static MTMatrix44 [rotationZ](MTMatrix44_rotation.cpp.md)(double alpha);

>static MTMatrix44 [rotation](MTMatrix44_rotation.cpp.md)(double phi, [MTCoordinates](MTCoordinates.hpp.md) const & axis);

>[MTMatrix44](MTMatrix44_ctor.cpp.md)();

>[MTMatrix44](MTMatrix44_ctor.cpp.md)(MTMatrix const & m);

>[MTMatrix44](MTMatrix44_ctor.cpp.md)(std::string const & m);

>virtual [~MTMatrix44](MTMatrix44_dtor.cpp.md)();

## /* brewery */

>//[code header](MTMatrix44-alpha-.md)();

>//[code trailer](MTMatrix44_-omega-.md)();

```cpp
};
} // namespace
```

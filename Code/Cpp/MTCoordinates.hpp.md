~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTVector.hpp"
#include "MTMatrix44.hpp"
#include "MTMatrix53.hpp"

#include <string>
~~~

namespace [mt](namespace_mt.list) {

# class MTCoordinates : public [MTVector](MTVector.hpp.md)

~~~ { .cpp }
{
public:
~~~

## /* comparison */

>bool [operator==](MTCoordinates_comparison.cpp.md)(MTCoordinates const & c) const;

## /* calculate dihedral angle */

>static double [calculateDihedralAngleBetween](MTCoordinates_calculateDihedralAngleBetween.cpp.md)( MTCoordinates const & p1, MTCoordinates const & p2, MTCoordinates const & p3, MTCoordinates const & p4);

## /* calculate distance */

>double [distance2To](MTCoordinates_distanceTo.cpp.md)(MTCoordinates const & c2) const;  // square distance

>double [distanceTo](MTCoordinates_distanceTo.cpp.md)(MTCoordinates const & c2) const;

>double [distanceToLineFrom](MTCoordinates_distanceTo.cpp.md)(MTCoordinates const & v2, MTCoordinates const & v3) const;

## /* setter */

>void [set](MTCoordinates_set.cpp.md)(double newx, double newy, double newz);

## /* getters */

>double [x](MTCoordinates_getters.cpp.md)() const;

>double [y](MTCoordinates_getters.cpp.md)() const;

>double [z](MTCoordinates_getters.cpp.md)() const;

## /* transform this coordinates */

>virtual void [transformBy](MTCoordinates_transformBy.cpp.md)(MTMatrix53 const & m);

>virtual void [rotateBy](MTCoordinates_rotateBy.cpp.md)(MTMatrix44 const & m);

>virtual void [translateBy](MTCoordinates_translateBy.cpp.md)(MTCoordinates const & v);

>MTMatrix44 [alignToZaxis](MTCoordinates_alignToZaxis.cpp.md)() const;

## /* creation */

>[MTCoordinates](MTCoordinates_ctor.cpp.md)(); // origin();

>[MTCoordinates](MTCoordinates_ctor.cpp.md)(double x, double y, double z);

>[MTCoordinates](MTCoordinates_ctor.cpp.md)(MTCoordinates const & p_coords);

>[MTCoordinates](MTCoordinates_ctor.cpp.md)(MTVector const & p_vect);

>virtual [~MTCoordinates](MTCoordinates_dtor.cpp.md)();

## /* brewery */

>//[code header](MTCoordinates_-alpha-.md)();

>//[code trailer](MTCoordinates_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~


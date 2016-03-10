~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include <memory>
#include <functional>

~~~

namespace [mt](namespace_mt.list) {

>class [MTAtom](MTAtom.hpp.md);

# class IAtomFactory
{

public:

> static int instance_count();

> virtual [~IAtomFactory](MTAtomFactory_dtor.cpp.md)();

> virtual void setFactory(std::function\\<MTAtom*()\\> const & fn) final { _factory = fn; }

> virtual MTAtom* [newInstance](MTAtomFactory_creation.cpp.md)() final;

protected:

> static std::function\\<MTAtom*()\\> _factory;

};

# class MTAtomFactory : public IAtomFactory
{

public:

## /* creation */

virtual MTAtom* [newAtom](MTAtomFactory_creation.cpp.md)(unsigned int serial, std::string const & name, double x = 0.0, double y = 0.0, double z = 0.0, double b = 0.0);

## /* ctor, dtor */

[MTAtomFactory](MTAtomFactory_ctor.cpp.md)();

virtual ~MTAtomFactory() {};

## /* brewery */

>//[code header](MTAtomFactory_-alpha-.md)();

>//[code trailer](MTAtomFactory_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~

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

>class [MTResidue](MTResidue.hpp.md);

# class IResidueFactory
{

public:

> static int instance_count();

> virtual void setFactory(std::function\\<MTResidue*()\\> const & fn) final { _factory = fn; }

> virtual std::shared_ptr\\<MTResidue\\> [newInstance](MTResidueFactory_creation.cpp.md)() final;

protected:

> static std::function\\<MTResidue*()\\> _factory;

};

# class MTResidueFactory : public IResidueFactory
{

public:

## /* creation */

virtual std::shared_ptr\\<MTResidue\\> [newResidue](MTResidueFactory_creation.cpp.md)(int num, std::string const & name, char subcode = ' ');

## /* ctor, dtor */

[MTResidueFactory](MTResidueFactory_ctor.cpp.md)();

virtual [~MTResidueFactory](MTResidueFactory_dtor.cpp.md)();

## /* brewery */

>//[code header](MTResidueFactory_-alpha-.md)();

>//[code trailer](MTResidueFactory_-omega-.md)();


~~~ { .cpp }
};

} // namespace
~~~


~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTModule.hpp"

#include <string>
#include <functional>

~~~

namespace [mt](namespace_mt.list) {

# class MTModuleLoader

~~~ { .cpp }
{
public:
~~~

## /* creation */

>static [MTModule](MTModule.hpp.md)* [load](MTModuleLoader_load.cpp.md)(std::string const & name);

>[MTModuleLoader](MTModuleLoader_ctor.cpp.md)();

>virtual [~MTModuleLoader](MTModuleLoader_dtor.cpp.md)();

## /* brewery */

>//[code header](MTModuleLoader_-alpha-)

>//[code trailer](MTModuleLoader_-omega-)

private:

> MTModuleLoader(MTModuleLoader const &) = delete;

> MTModuleLoader & operator=(MTModuleLoader const &) = delete;

>struct pimpl;

>std::unique_ptr\\<pimpl\\> _pimpl;

~~~ { .cpp }
};

} // namespace
~~~


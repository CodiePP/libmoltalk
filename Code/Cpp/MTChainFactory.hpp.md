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

>class MTChain;

# class IChainFactory
{

public:

 virtual [~IChainFactory](MTChainFactory_dtor.cpp.md)();

 static int instance_count();

 virtual void setFactory(std::function\\<MTChain*(char)\\> const & fn) final { _factory = fn; }

 virtual std::shared_ptr\\<MTChain\\> newInstance(char code = 'X') final;

protected:

	static std::function\\<MTChain*(char)\\> _factory;

};

# class MTChainFactory : public IChainFactory
{

public:

## /* creation */

virtual std::shared_ptr\\<[MTChain](MTChain.hpp)\\> [newChain](MTChainFactory_creation.cpp.md)(char code);

virtual std::shared_ptr\\<[MTChain](MTChain.hpp)\\> [createAAChainWithSequence](MTChainFactory_creation.cpp.md)(char code, std::string const & p_seq);

## /* ctor, dtor */

[MTChainFactory](MTChainFactory_ctor.cpp.md)();

virtual ~MTChainFactory() {};

## /* brewery */

>//[code header](MTChainFactory_-alpha-.md)();

>//[code trailer](MTChainFactory_-omega-.md)();

~~~ { .cpp }
};

} // namespace
~~~

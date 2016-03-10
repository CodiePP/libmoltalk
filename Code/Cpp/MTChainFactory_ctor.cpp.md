
declared in [MTChainFactory](MTChainFactory.hpp.md)

~~~ { .cpp }
std::function<MTChain*(char)> IChainFactory::_factory =  
	([](char c)->mt::MTChain*{ return new MTChain(c); });

MTChainFactory::MTChainFactory()
{ }
~~~


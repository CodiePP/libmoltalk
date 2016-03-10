
declared in [MTStructureFactory](MTStructureFactory.hpp.md)

~~~ { .cpp }
std::function<MTStructure*()> IStructureFactory::_factory = 
	([]()->MTStructure*{ return new MTStructure(); });

MTStructureFactory::MTStructureFactory()
{ }
~~~


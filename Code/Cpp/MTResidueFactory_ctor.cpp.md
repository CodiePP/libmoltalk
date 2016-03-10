
declared in [MTResidueFactory](MTResidueFactory.hpp.md)

~~~ { .cpp }
std::function<MTResidue*()> IResidueFactory::_factory =
	([]()->MTResidue*{ return new MTResidue(); });

MTResidueFactory::MTResidueFactory()
{ }
~~~


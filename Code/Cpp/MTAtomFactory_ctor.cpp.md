
declared in [MTAtomFactory](MTAtomFactory.hpp.md)

~~~ { .cpp }
std::function<MTAtom*()> IAtomFactory::_factory =
	([]()->mt::MTAtom*{ return new MTAtom(); });

MTAtomFactory::MTAtomFactory()
{ }
~~~


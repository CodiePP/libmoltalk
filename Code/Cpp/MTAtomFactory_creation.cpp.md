
declared in [MTAtomFactory](MTAtomFactory.hpp.md)

~~~ { .cpp }
MTAtom* IAtomFactory::newInstance()
{
    if (_factory) {
	++_instance_counter;
        return _factory(); }
    return nullptr;
}
~~~

~~~ { .cpp }
MTAtom* MTAtomFactory::newAtom(unsigned int serial, std::string const & name, double x, double y, double z, double b)
{
	auto inst = newInstance();
	if (inst) {
		inst->setName(name);
		inst->setSerial(serial);
		inst->setXYZB(x, y, z, b); }
	return inst;
}
~~~


declared in [MTResidueFactory](MTResidueFactory.hpp.md)

~~~ { .cpp }
MTResidue* IResidueFactory::newInstance()
{
    if (_factory) {
	++_instance_counter;
        return _factory(); }
    return nullptr;
}
~~~

~~~ { .cpp }
MTResidue* MTResidueFactory::newResidue(int num, std::string const & name, char subcode)
{
	auto inst = newInstance();
	if (inst) {
		inst->name(name);
		inst->number(num);
		inst->subcode(subcode); }
	return inst;
}
~~~

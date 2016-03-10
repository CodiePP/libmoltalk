
declared in [MTResidueFactory](MTResidueFactory.hpp.md)

~~~ { .cpp }
std::shared_ptr<MTResidue> IResidueFactory::newInstance()
{
    if (_factory) {
	++_instance_counter;
        return std::shared_ptr<MTResidue>(_factory()); }
    return nullptr;
}
~~~

~~~ { .cpp }
std::shared_ptr<MTResidue> MTResidueFactory::newResidue(int num, std::string const & name, char subcode)
{
	auto inst = newInstance();
	if (inst) {
		inst->name(name);
		inst->number(num);
		inst->subcode(subcode); }
	return inst;
}
~~~


declared in [MTChainFactory](MTChainFactory.hpp.md)

~~~ { .cpp }
MTChain* IChainFactory::newInstance(char code)
{
    if (_factory) {
	++_instance_counter;
        return _factory(code); }
    return nullptr;
}
~~~

~~~ { .cpp }
MTChain* MTChainFactory::newChain(char code)
{
    if (_factory) {
        return newInstance(code); }
    return nullptr;
}
~~~

TODO  :exclamation:
~~~ { .cpp }
MTChain* MTChainFactory::createAAChainWithSequence(char code, std::string const & p_seq)
{
    if (_factory) {
	MTResidueFactory _rfactory;
	_rfactory.setFactory([]()->MTResidue* { return new MTResidueAA(); });
	auto _ch = newInstance(code);
	char rn[] = {'\\0', '\\0'};
	int ri = 1;
	for (char r : p_seq) {
		rn[0]=r;
		const std::string rnm(MTResidueAA::translate1to3Code(rn));
		std::clog << " residue " << r << " => " << rnm << std::endl;
		auto rp = _rfactory.newInstance();
		rp->number(ri++);
		rp->name(rnm);
		_ch->addResidue(rp);
	}
        return std::move(_ch); }
    return nullptr;
}
~~~


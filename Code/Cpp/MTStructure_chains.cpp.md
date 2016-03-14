
declared in [MTStructure](MTStructure.hpp.md)

~~~ { .cpp }
MTChain* MTStructure::findChain(std::function<bool(MTChain* const &)> const & fn) const
{
        for (auto const & e : _pimpl->_chains()) {
                if (fn(e)) { return e; }
        }
	return nullptr;
}

void MTStructure::removeChain(MTChain* p_ch)
{
	if (! p_ch) { return; }
        auto it = std::find_if(_pimpl->_chains().begin(), _pimpl->_chains().end(), [&p_ch](MTChain* & chain) -> bool {
                return (p_ch->number() == chain->number());
        });
        if (it != _pimpl->_chains().end()) {
                _pimpl->_chains().erase(it); }

}
void MTStructure::addChain(MTChain* p_ch)
{
	if (p_ch) {
		int n = p_ch->number();
		auto t_ch = findChain([n](MTChain* const & c)->bool {
			return (c->number() == n); });
		if (! t_ch) {
			_pimpl->_chains().push_back(p_ch); }
	}
}
MTChain* MTStructure::getChain(int p_ch) const
{
	return findChain([p_ch](MTChain* const & c)->bool {
		return (c->number() == p_ch); });
}
MTChain* MTStructure::getChain(char p_ch) const
{
	return getChain(int(p_ch));
}
~~~


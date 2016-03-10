
declared in [MTStructure](MTStructure.hpp.md)

~~~ { .cpp }
std::shared_ptr<MTChain> MTStructure::findChain(std::function<bool(std::shared_ptr<MTChain> const &)> const & fn) const
{
        for (auto const & e : _pimpl->_chains()) {
                if (fn(e)) { return e; }
        }
	return nullptr;
}

void MTStructure::removeChain(std::shared_ptr<MTChain> p_ch)
{
	if (! p_ch) { return; }
        auto it = std::find_if(_pimpl->_chains().begin(), _pimpl->_chains().end(), [&p_ch](std::shared_ptr<MTChain> & chain) -> bool {
                return (p_ch->number() == chain->number());
        });
        if (it != _pimpl->_chains().end()) {
                _pimpl->_chains().erase(it); }

}
void MTStructure::addChain(std::shared_ptr<MTChain> p_ch)
{
	if (p_ch) {
		int n = p_ch->number();
		auto t_ch = findChain([n](std::shared_ptr<MTChain> const & c)->bool {
			return (c->number() == n); });
		if (! t_ch) {
			_pimpl->_chains().push_back(p_ch); }
	}
}
std::shared_ptr<MTChain> MTStructure::getChain(int p_ch) const
{
	return findChain([p_ch](std::shared_ptr<MTChain> const & c)->bool {
		return (c->number() == p_ch); });
}
std::shared_ptr<MTChain> MTStructure::getChain(char p_ch) const
{
	return getChain(int(p_ch));
}
~~~


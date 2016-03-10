
declared in [MTStructure](MTStructure.hpp.md)

~~~ { .cpp }
int MTStructure::models() const
{
	return _pimpl->_nmodels;
}
int MTStructure::currentModel() const
{
	return _pimpl->_currmodel;
}
int MTStructure::switchToModel(int p_mnum)
{
	if (p_mnum > 0 && p_mnum <= _pimpl->_nmodels) {
		_pimpl->_currmodel = p_mnum; }
	return _pimpl->_currmodel;
}
int MTStructure::addModel()
{
	_pimpl->_models.push_back( std::list<std::shared_ptr<MTChain>>() );
	_pimpl->_currmodel = ++_pimpl->_nmodels;
	return _pimpl->_currmodel;
}
void MTStructure::removeModel()
{
	if (_pimpl->_nmodels < 2) { return; }
	_pimpl->_models.at(_pimpl->_currmodel - 1).clear();
	_pimpl->_currmodel = --_pimpl->_nmodels;
}
~~~


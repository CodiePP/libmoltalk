
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
std::shared_ptr<MTResidue> MTChain::getResidue(unsigned int num, char subcode) const
{
	std::string id = MTResidue::computeKey(num, subcode);
	auto r = _residues.find(id);
	if (r != _residues.cend()) {
		//std::clog << "MTChain::getResidue found: " << id << std::endl;
		return r->second; }
	r = _heterogens.find(id);
	if (r != _heterogens.cend()) {
		//std::clog << "MTChain::getResidue found: " << id << std::endl;
		return r->second; }
	r = _solvent.find(id);
	if (r != _solvent.cend()) {
		//std::clog << "MTChain::getResidue found: " << id << std::endl;
		return r->second; }
	//std::clog << "MTChain::getResidue NOT found: " << id << std::endl;
	return nullptr;
}

std::shared_ptr<MTResidue> MTChain::findResidue(std::function<bool(std::shared_ptr<MTResidue> const &)> const & fn) const
{
	for (auto const & e : _residues) {
		if (e.second && fn(e.second)) { return e.second; }
	}
	return nullptr;
}

std::shared_ptr<MTResidue> MTChain::getHeterogen(unsigned int num, char subcode) const
{
	std::string id = MTResidue::computeKey(num, subcode);
	auto r = _heterogens.find(id);
	if (r != _heterogens.cend()) {
		return r->second; }
	return nullptr;
}

std::shared_ptr<MTResidue> MTChain::findHeterogen(std::function<bool(std::shared_ptr<MTResidue> const &)> const & fn) const
{
	for (auto const & e : _heterogens) {
		if (e.second && fn(e.second)) { return e.second; }
	}
	return nullptr;
}

std::shared_ptr<MTResidue> MTChain::getSolvent(unsigned int num, char subcode) const
{
	std::string id = MTResidue::computeKey(num, subcode);
	auto r = _solvent.find(id);
	if (r != _solvent.cend()) {
		return r->second; }
	return nullptr;
}

std::shared_ptr<MTResidue> MTChain::findSolvent(std::function<bool(std::shared_ptr<MTResidue> const &)> const & fn) const
{
	for (auto const & e : _solvent) {
		if (e.second && fn(e.second)) { return e.second; }
	}
	return nullptr;
}

~~~


original objc code:

~~~ { .ObjectiveC }

~~~

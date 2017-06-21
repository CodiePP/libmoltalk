
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
std::string MTChain::getSEQRES() const
{
	std::string _s;
	if (getDescriptor("SEQRES", _s)) {
		return _s; }
	return "";
}

struct MTResidueCmp {
    bool operator()(MTResidue const *lhs, MTResidue const *rhs) const { 
        return lhs->number() < rhs->number(); 
    }
};

std::string MTChain::getSequence() const
{
	std::set<MTResidue*,MTResidueCmp> sortres;
	for (auto const & e : _residues) {
		if (e.second && e.second->isStandardAminoAcid()) {
			sortres.insert(e.second);
    } else {
      std::clog << "residue " << e.second->name() << e.second->number() << " is not standard residue!" << std::endl;
    }
	}
	int _lastpos = -1;
	std::string _seq("");
	for (auto const & res : sortres) {
		if (_lastpos < 0) { _lastpos = res->number(); }
		int _diff = res->number() - _lastpos;
		_diff = std::min(99, _diff); // limit insertion
		//std::clog << "last: " << _lastpos << " pos: " << res->number() << " diff: " << _diff << std::endl;
		for (int i = 1; i < _diff; i++) {
			_seq += "X";
		}
		_lastpos = res->number();
		_seq += res->oneLetterCode();
	}
	return _seq;
}

std::string MTChain::get3DSequence() const
{
	std::set<MTResidue*,MTResidueCmp> sortres;
	for (auto const & e : _residues) {
		if (e.second && e.second->isStandardAminoAcid()) {
			sortres.insert(e.second); }
	}
	std::string _seq("");
	for (auto const & res : sortres) {
		_seq += res->oneLetterCode();
	}
	return _seq;
}
~~~


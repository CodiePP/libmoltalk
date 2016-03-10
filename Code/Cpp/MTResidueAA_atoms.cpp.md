
declared in [MTResidueAA](MTResidueAA.hpp.md)

~~~ { .cpp }

MTAtom* MTResidueAA::getCA() const
{
	return getAtom(" CA");
}

MTAtom* MTResidueAA::findAtom(std::function<bool(MTAtom*)> const & fn) const
{
	for (auto a : _atoms) {
		if (fn(a)) { return a; }
	}
	return nullptr;
}

void MTResidueAA::addAtom(MTAtom* a)
{
	auto it = std::find_if(_atoms.begin(), _atoms.end(), [&a](MTAtom* atm) -> bool {
		if (a->serial() != atm->serial()) { return false; }
		if (a->name() != atm->name()) { return false; }
		return true;
	});
	if (it == _atoms.end()) {
		std::clog << "addAtom '" << a->name() << "' " << a->serial() << std::endl;
		_atoms.push_back(a); }
}

void MTResidueAA::removeAtom(MTAtom* a)
{
	auto it = std::find_if(_atoms.begin(), _atoms.end(), [&a](MTAtom* atm) -> bool {
		if (a->serial() != atm->serial()) { return false; }
		if (a->name() != atm->name()) { return false; }
		return true;
	});
	if (it != _atoms.end()) {
		_atoms.erase(it); }
}

int MTResidueAA::allAtoms(std::function<void(MTAtom*)> const & fn)
{
	int cnt=0;
	for (auto a : _atoms) {
		fn(a);
		cnt++;
	}
	return cnt;
}

~~~


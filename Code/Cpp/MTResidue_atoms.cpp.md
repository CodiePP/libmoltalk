
declared in [MTResidue](MTResidue.hpp.md)

~~~ { .cpp }

MTAtom* MTResidue::getCA() const
{
	return getAtom(" CA");
}

MTAtom* MTResidue::getAtom(std::string as) const
{
	std::string as_p(" ");
	as_p += as;
	return findAtom([&as_p,&as](MTAtom* a)->bool {
		return (a->name() == as || a->name() == as_p);
	});
	return nullptr;
}

MTAtom* MTResidue::getAtom(unsigned int ai) const
{
	return findAtom([ai](MTAtom* a)->bool {
		return (a->serial() == ai);
	});
}

MTAtom* MTResidue::findAtom(std::function<bool(MTAtom*)> const & fn) const
{
	for (auto a : _atoms) {
		if (fn(a)) { return a; }
	}
	return nullptr;
}

void MTResidue::addAtom(MTAtom* a)
{
	auto it = std::find_if(_atoms.begin(), _atoms.end(), [a](MTAtom* atm) -> bool {
		return ( (a->serial() == atm->serial()) && (a->name() == atm->name()) );
	});
	if (it == _atoms.end()) {
		std::clog << "addAtom '" << a->name() << "' " << a->serial() << std::endl;
		_atoms.push_back(a); }
}

void MTResidue::removeAtom(MTAtom* a)
{
	if (!a) { return; }
	auto it = std::find_if(_atoms.begin(), _atoms.end(), [a](MTAtom* atm) -> bool {
		return ( (a->serial() == atm->serial()) && (a->name() == atm->name()) );
	});
	if (it != _atoms.end()) {
		_atoms.erase(it); }
}

void MTResidue::removeAtom(std::string const & n)
{
	if (n.empty()) { return; }
	auto it = std::find_if(_atoms.begin(), _atoms.end(), [&n](MTAtom* atm) -> bool {
		return (atm->name() == n);
	});
	if (it != _atoms.end()) {
		_atoms.erase(it); }
}

int MTResidue::allAtoms(std::function<void(MTAtom*)> const & fn)
{
	int cnt=0;
	for (auto a : _atoms) {
		fn(a);
		cnt++;
	}
	return cnt;
}

~~~


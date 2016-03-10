
declared in [MTAtom](MTAtom.hpp.md)

~~~ { .cpp }
void MTAtom::bondTo(MTAtom* a)
{
	auto it = find_if(_bonds.begin(), _bonds.end(), [a](MTAtom *b)->bool {
		return (a == b); });
	if (it == _bonds.end()) {
		_bonds.push_back(a); }
}

void MTAtom::dropBondTo(MTAtom* a)
{
	auto it = find_if(_bonds.begin(), _bonds.end(), [a](MTAtom *b)->bool {
		return (a == b); });
	if (it != _bonds.end()) {
		_bonds.erase(it); }
}

void MTAtom::dropAllBonds()
{
	for (auto a : _bonds) {
		a->dropBondTo(this);
	}
	_bonds.clear();
}

const std::list<MTAtom*> MTAtom::allBondedAtoms() const
{
	return _bonds;
}

MTAtom* MTAtom::findBondedAtom(std::function<bool(MTAtom*)> const & fn) const
{
        for (auto a : _bonds) {
                if (fn(a)) { return a; }
        }
        return nullptr;
}

~~~


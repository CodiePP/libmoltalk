
declared in [MTSelection](MTSelection.hpp.md)

~~~ { .cpp }
bool MTSelection::containsResidue(MTResidue * const r) const
{
    auto it = std::find_if(_residues.cbegin(), _residues.cend(),
            [r](MTResidue* const r2)->bool {
                return (r == r2); });
    return (it != _residues.cend());
}

void MTSelection::addResidue(MTResidue *r)
{
    if (! containsResidue(r)) {
        _residues.push_back(r); }
}

void MTSelection::removeResidue(MTResidue * const r)
{
    auto it = std::find_if(_residues.begin(), _residues.end(),
            [r](MTResidue* const r2)->bool {
                return (r == r2); });
    if (it != _residues.end()) {
        _residues.erase(it); }
}

void MTSelection::setDifference(MTSelection const *s)
{
    for (auto r : s->getSelection()) {
        removeResidue(r); }
}

void MTSelection::setUnion(MTSelection const *s)
{
    for (auto r : s->getSelection()) {
        addResidue(r); }
}

~~~

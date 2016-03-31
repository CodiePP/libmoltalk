
declared in [MTSelection](MTSelection.hpp.md)

~~~ { .cpp }
bool MTSelection::containsResidue(MTResidue * const r) const
{
    return std::find_if(_residues.cbegin(), _residues.cend(),
        [r](std::list<MTResidue*>::const_iterator it)->bool {
            return (r == *it); });
}

void MTSelection::addResidue(MTResidue *r)
{
    if (! containsResidue(r)) {
        _residues.push_back(r); }
}

void MTSelection::removeResidue(MTResidue * const r)
{
    remove_if(_residues.begin(), _residues.end(),
        [r](MTResidue const *r2)->bool {
            return (r2 == r); });
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

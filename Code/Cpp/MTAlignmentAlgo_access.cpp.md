
declared in [MTAlignmentAlgo](MTAlignmentAlgo.hpp.md)

~~~ { .cpp }

void MTAlignmentAlgo::selectAligned(MTSelection & sel1, MTSelection & sel2) const
{
    if (! _computed) { return; }
    if (! _chain1) { return; }
    if (! _chain2) { return; }
    MTSelection s1(_chain1);
    MTSelection s2(_chain1);

    for (auto const alp : _positions) {
        if (!alp.isGapped()) {
            s1.addResidue(alp.residue1());
            s2.addResidue(alp.residue2()); }
    }

    sel1 = s1;
    sel2 = s2;
}

void MTAlignmentAlgo::selectGapped(MTSelection & sel1, MTSelection & sel2) const
{
    if (! _computed) { return; }
    if (! _chain1) { return; }
    if (! _chain2) { return; }
    MTSelection s1(_chain1);
    MTSelection s2(_chain1);

    for (auto const alp : _positions) {
        if (alp.residue1() && !alp.residue2()) {
            s1.addResidue(alp.residue1()); }
        if (alp.residue2() && !alp.residue1()) {
            s2.addResidue(alp.residue2()); }
    }

    sel1 = s1;
    sel2 = s2;
}

std::list\<MTAlPos\>::const_iterator MTAlignmentAlgo::cbegin() const
{
    return _positions.cbegin();
}

std::list\<MTAlPos\>::const_iterator MTAlignmentAlgo::cend() const
{
    return _positions.cend();
}

std::string MTAlignmentAlgo::toString() const
{
    std::string s;
    MTResidue *r1, *r2;
    for (auto const & p : _positions) {
        r1 = p.residue1();
        r2 = p.residue2();
        if (r1) { s += r1->oneLetterCode(); }
        else    { s += "-"; }
        s += " ";
        if (r2) { s += r2->oneLetterCode(); }
        else    { s += "-"; }
        s += "\\n";
    }

    return s;
}

std::string MTAlignmentAlgo::toFasta() const
{
    std::ostringstream os;
    os << "> pairwise seq al " << _chain1->name() << " to " << _chain2->name()
    << std::endl;
    std::for_each(_positions.crbegin(), _positions.crend(), [&os](mt::MTAlPos const & alpos) {
        if (alpos.residue1()) {
            os << alpos.residue1()->oneLetterCode() << " "; }
        else {
            os << "- "; }
        });
    os << std::endl;
    std::for_each(_positions.crbegin(), _positions.crend(), [&os](mt::MTAlPos const & alpos) {
        if (alpos.residue2()) {
            os << alpos.residue2()->oneLetterCode() << " "; }
        else {
            os << "- "; }
        });
    os << std::endl;
    return os.str();
}

int MTAlignmentAlgo::countAligned() const
{
    if (!_computed) { return -1; }
    int i=0;
    for (auto const & alp : _positions) {
        if (alp.residue1() && alp.residue2()) { ++i; }
    }
    return i;
}

int MTAlignmentAlgo::countIdentical() const
{
    if (!_computed) { return -1; }
    int i=0;
    for (auto const & alp : _positions) {
        if (alp.residue1() && alp.residue2()) {
            if (alp.residue1()->name() == alp.residue2()->name()) {
                ++i; } }
    }
    return i;
}

int MTAlignmentAlgo::countGapped() const
{
    if (!_computed) { return -1; }
    int i=0;
    for (auto const & alp : _positions) {
        if (!alp.residue1() || !alp.residue2()) { ++i; }
    }
    return 0;
}

~~~


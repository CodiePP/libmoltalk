
declared in [MTAlignmentAlgo](MTAlignmentAlgo.hpp.md)

~~~ { .cpp }

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
	return "";
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


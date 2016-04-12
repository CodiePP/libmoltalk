
declared in [MTSelection](MTSelection.hpp.md)

~~~ { .cpp }
MTMatrix53 MTSelection::alignTo(MTSelection const & sel2) const
{
    MTMatrix53 res;
    if (count() == 0 || count() != sel2.count()) {
        std::clog << "MTSelection::alignTo needs two selections with equal size"
        << std::endl;
        return res; }

    MTMatrix m1(count(), 3);
    MTMatrix m2(count(), 3);
    MTResidue * r;
    MTAtom * a;
    int n1 = 0;
    for (MTResidue const * r : _residues) {
        if (r) {
            a = r->getCA();
            if (a) {
                MTCoordinates c = a->coords();
                m1.atRowColValue(n1, 0, c.x());
                m1.atRowColValue(n1, 1, c.y());
                m1.atRowColValue(n1, 2, c.z());
                n1++;
            }
        }
    }
    
    int n2 = 0;
    for (MTResidue const * r : sel2._residues) {
        if (r) {
            a = r->getCA();
            if (a) {
                MTCoordinates c = a->coords();
                m1.atRowColValue(n2, 0, c.x());
                m1.atRowColValue(n2, 1, c.y());
                m1.atRowColValue(n2, 2, c.z());
                n2++;
            }
        }
    }

    if (n1 == n2 && n1 >= 3) {
        return m1.alignTo(m2); }

    return res;
}

~~~

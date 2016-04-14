
declared in [MTResidueAA](MTResidueAA.hpp.md)

~~~ { .cpp }
double MTResidueAA::distanceCATo(MTResidue const * const r2) const
{
    MTAtom *a1 = getCA();
    if (! a1) { return 0.0; }
    MTAtom *a2 = r2->getCA();
    if (! a2) { return 0.0; }

    return a1->distanceTo(a2);
}
~~~


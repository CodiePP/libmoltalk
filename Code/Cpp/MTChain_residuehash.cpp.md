
declared in [MTChain](MTChain.hpp.md)

## prepareResidueHash

We calculate the number of bits to encode the MAX_RANGE divided by the given
bin width.
~~~ { .cpp }
void MTChain::prepareResidueHash(float binwidth)
{
    int bits = (int)(log(MTCoordinates::MAX_RANGE / binwidth) / log(2.0) + 0.5);
    prepareResidueHash(bits);
}
~~~

~~~ { .cpp }
void MTChain::prepareResidueHash(int bits)
{
    if (bits < 6 || bits > 10) { return; }

    _residuehash = {};
    _hashingbits = bits;
    auto fn = [this,bits](MTResidue *r) {
        if (r) {
            r->findAtom([this,bits,r](MTAtom *a)->bool {
                if (a) {
                    auto c = a->coords();
                    long h = c.hash(bits);
                    auto it = _residuehash.find(h);
                    if (it == _residuehash.end()) {
                        _residuehash[h] = { r }; }
                    else {
                        it->second.insert(r); }
                }
                return false;
            });
        }
    };
    findResidue([this,fn](MTResidue * r)->bool {
        fn(r); return false; });
    findHeterogen([this,fn](MTResidue * r)->bool {
        fn(r); return false; });
}
~~~

## findResiduesCloseTo MTCoordinates

~~~ { .cpp }
std::list<MTResidue*> MTChain::findResiduesCloseTo(MTCoordinates const & coords) const
{
    std::list<MTResidue*> l;
    if (_hashingbits == 0) { return l; }

    long h = coords.hash(_hashingbits);
    auto it = _residuehash.find(h);
    if (it != _residuehash.end()) {
        for (auto r : it->second) {
            l.push_back(r); }
    }

    return l;
}
~~~

## findResiduesCloseTo MTChain

~~~ { .cpp }
std::list<MTResidue*> MTChain::findResiduesCloseTo(MTChain * c2, float maxdist) const
{
    if (_hashingbits == 0) { return {}; }

    std::set<MTResidue*> l;
    c2->prepareResidueHash(8);
    filterResidues([this,&l,c2,maxdist](MTResidue *r)->bool {
        MTAtom *a = r->getCA();
        if (a) {
            MTCoordinates co = a->coords();
            auto lres = c2->findResiduesCloseTo(co);
            std::remove_if(lres.begin(), lres.end(), 
                [maxdist,&co](MTResidue *r2)->bool {
                    MTAtom *a = r2->getCA();
                    if (a) {
                        double d2 = co.distance2To(a->coords());
                        if (d2 < maxdist) { return false; }
                    }
                    return true;
                });
            for_each(lres.begin(), lres.end(), [&l](MTResidue *r){
                l.emplace(r); });
        }
    });
    return {l.begin(), l.end()};
}
~~~


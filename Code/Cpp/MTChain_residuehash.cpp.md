
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

## findResiduesCloseTo

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


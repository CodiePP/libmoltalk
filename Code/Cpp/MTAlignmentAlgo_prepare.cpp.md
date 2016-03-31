
declared in [MTAlignmentAlgo](MTAlignmentAlgo.hpp.md)

~~~ { .cpp }

void MTAlignmentAlgo::prepare_alignment()
{
    _substm = new MTSubstitutionMatrixBlosum62();

    /* prepare sequence 1 and 2 */
    std::list<MTResidue*> lres;
    if (_chain1) {
        _seq1 = _chain1->get3DSequence(); }
    else {
        MTChainFactory _cf;
        _chain1 = _cf.createAAChainWithSequence('A', _seq1);
    }
    lres = _chain1->filterResidues([](MTResidue* r)->bool { return r->isStandardAminoAcid(); });
    lres.sort([](MTResidue *r1, MTResidue *r2)->bool {
            return r1->number() < r2->number();
            });
    _residues1 = std::vector<MTResidue*>(lres.begin(), lres.end());

    if (_chain2) {
        _seq2 = _chain2->get3DSequence(); }
    else {
        MTChainFactory _cf;
        _chain2 = _cf.createAAChainWithSequence('B', _seq2);
    }
    lres = _chain2->filterResidues([](MTResidue* r)->bool { return r->isStandardAminoAcid(); });
    lres.sort([](MTResidue *r1, MTResidue *r2)->bool {
            return r1->number() < r2->number();
            });
    _residues2 = std::vector<MTResidue*>(lres.begin(), lres.end());

}

~~~

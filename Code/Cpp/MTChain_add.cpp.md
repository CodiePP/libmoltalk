
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
void MTChain::addResidue(std::shared_ptr<MTResidue> r)
{
	if (_residues.count(r->key()) == 0) {
		_residues[r->key()] = r; }
}

void MTChain::addHeterogen(std::shared_ptr<MTResidue> h)
{
	if (_heterogens.count(h->key()) == 0) {
		_heterogens[h->key()] = h; }
}

void MTChain::addSolvent(std::shared_ptr<MTResidue> s)
{
	if (_solvent.count(s->key()) == 0) {
		_solvent[s->key()] = s; }
}
~~~


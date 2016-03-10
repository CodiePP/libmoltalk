
declared in [MTChain](MTChain.hpp.md)

~~~ { .cpp }
void MTChain::removeResidue(unsigned int num, char subcode)
{
        std::string id = MTResidue::computeKey(num, subcode);
	_residues.erase(id);
}
void MTChain::removeHeterogen(unsigned int num, char subcode)
{
        std::string id = MTResidue::computeKey(num, subcode);
	_heterogens.erase(id);
}
void MTChain::removeSolvent(unsigned int num, char subcode)
{
        std::string id = MTResidue::computeKey(num, subcode);
	_solvent.erase(id);
}
~~~


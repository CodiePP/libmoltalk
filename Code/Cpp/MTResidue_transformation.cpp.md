
declared in [MTResidue](MTResidue.hpp.md)

~~~ { .cpp }
void MTResidue::transformBy(MTMatrix53 const & m)
{
	auto fn = [&m](MTAtom* a)->void {
		a->transformBy(m); };
	allAtoms(fn);
}

void MTResidue::rotateBy(MTMatrix44 const & m)
{
	auto fn = [&m](MTAtom* a)->void {
		a->rotateBy(m); };
	allAtoms(fn);
}

void MTResidue::translateBy(MTCoordinates const & c)
{
	auto fn = [&c](MTAtom* a)->void {
		a->translateBy(c); };
	allAtoms(fn);
}

void MTResidue::mutateTo(MTResidue const & r)
{
}
~~~


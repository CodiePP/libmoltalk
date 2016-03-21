
declared in [MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment.hpp.md)

~~~ { .cpp }

#include "MTPairwiseSequenceAlignment.hpp"
#include "MTSubstitutionMatrix.hpp"
#include "MTAlPos.hpp"
#include "MTResidue.hpp"
#include "MTChain.hpp"

#include <iostream>
#include <cstring>

#include "boost/format.hpp"

namespace mt {

#define GAPOPENINGPENALTY 10.0f 
#define GAPEXTENDPENALTY 1.0f

struct MTPairwiseSequenceAlignment::pimpl {
	pimpl();
	~pimpl();

	bool _computed { false };

	float  _gop { GAPOPENINGPENALTY };
	float _gep { GAPEXTENDPENALTY };

	int _startpos, _endpos;

	const MTChain* _chain1 { nullptr };
	const MTChain* _chain2 { nullptr };

	std::string _seq1, _seq2;

	MTSubstitutionMatrix *_substm;

	std::list<MTAlPos> _positions;
};

MTPairwiseSequenceAlignment::pimpl::pimpl()
{
	_substm = new MTSubstitutionMatrixBlosum62();
}

MTPairwiseSequenceAlignment::pimpl::~pimpl()
{
	if (_substm) { delete _substm; }
}

~~~

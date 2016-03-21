~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

~~~

namespace [mt](namespace_mt.list) {

# class MTSubstitutionMatrix

> // defines the interface

~~~ { .cpp }
{
public:

	MTSubstitutionMatrix() {};

	virtual ~MTSubstitutionMatrix() {};

	virtual float scoreBetween(char c1, char c2) const = 0;

private:

	MTSubstitutionMatrix(MTSubstitutionMatrix const &) = delete;

	MTSubstitutionMatrix & operator=(MTSubstitutionMatrix const &) = delete;

};

~~~


# class MTSubstitutionMatrixIdentity : public MTSubstitutionMatrix

> // fixed penalty for mismatch between amino acids.

~~~ { .cpp }
{
public:
	MTSubstitutionMatrixIdentity() {};
	virtual ~MTSubstitutionMatrixIdentity() {};
~~~

> virtual float [scoreBetween](MTSubstitutionMatrix_identiyy_scoreBetween.cpp.md)(char c1, char c2) const override;

~~~ { .cpp }
};
~~~


# class MTSubstitutionMatrixBlosum45 : public MTSubstitutionMatrix

> // implements the Blosum45 scoring.

~~~ { .cpp }
{
public:
	MTSubstitutionMatrixBlosum45() {};
	virtual ~MTSubstitutionMatrixBlosum45() {};
~~~

> virtual float [scoreBetween](MTSubstitutionMatrix_blosum45_scoreBetween.cpp.md)(char c1, char c2) const override;

~~~ { .cpp }
};
~~~


# class MTSubstitutionMatrixBlosum62 : public MTSubstitutionMatrix

> // implements the Blosum62 scoring.

~~~ { .cpp }
{
public:
	MTSubstitutionMatrixBlosum62() {};
	virtual ~MTSubstitutionMatrixBlosum62() {};
~~~

> virtual float [scoreBetween](MTSubstitutionMatrix_blosum62_scoreBetween.cpp.md)(char c1, char c2) const override;

~~~ { .cpp }
};
~~~


# class MTSubstitutionMatrixBlosum80 : public MTSubstitutionMatrix

> // implements the Blosum80 scoring.

~~~ { .cpp }
{
public:
	MTSubstitutionMatrixBlosum80() {};
	virtual ~MTSubstitutionMatrixBlosum80() {};
~~~

> virtual float [scoreBetween](MTSubstitutionMatrix_blosum80_scoreBetween.cpp.md)(char c1, char c2) const override;

~~~ { .cpp }
};
~~~


## /* brewery */

>//[code header](MTSubstitutionMatrix_-alpha-.md)();

>//[code trailer](MTSubstitutionMatrix-omega-.md)();


~~~ { .cpp }

} // namespace
~~~

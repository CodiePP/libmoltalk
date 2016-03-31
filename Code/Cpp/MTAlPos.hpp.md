~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

~~~

namespace [mt](namespace_mt.list) {

>class [MTAlignmentAlgo](MTAlignmentAlgo.hpp.md);

>class [MTResidue](MTResidue.hpp.md);

# class MTAlPos

~~~ { .cpp }
{
public:
~~~

>MTAlPos(MTResidue* r1, MTResidue* r2) : _res1(r1),_res2(r2) { };

>virtual ~MTAlPos() { };

>bool isGapped() const { return (_res1 == nullptr || _res2 == nullptr); }

>double distance() const { return _dist; }

>MTResidue* residue1() const { return _res1; }

>MTResidue* residue2() const { return _res2; }

protected:
friend MTAlignmentAlgo;

>void set(MTResidue* r1, MTResidue* r2) { _res1 = r1; _res2 = r2; }

>void set(double d) { _dist = d; }

private:

>double _dist {0.0};

>MTResidue* _res1;

>MTResidue* _res2;

>MTAlPos() = delete;

>//MTAlPos(MTAlPos const &) = delete;

>//MTAlPos & operator=(MTAlPos const &) = delete;

~~~ { .cpp }
};

} // namespace
~~~

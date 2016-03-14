~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include <string>
~~~

namespace [mt](namespace_mt.list) {

# class MTVector  

{
public:
    
##  /* access */

>int [dimensions](MTVector_access.cpp.md)() const;

>std::string [toString](MTVector_access.cpp.md)() const;

>std::string [description](MTVector_access.cpp.md)() const;

>void [atDim](MTVector_access.cpp.md)(int dim, double v);

>double [atDim](MTVector_access.cpp.md)(int dim) const;

>void set(int dim, double v) { atDim(dim, v); }

>double get(int dim) const { return atDim(dim); }

## /* comparison */

>bool [operator==](MTVector_comparison.cpp.md)(MTVector const &) const;

##  /* operations */

>MTVector& [operator-=](MTVector_add.cpp.md)(MTVector const & v2);

>MTVector& [operator+=](MTVector_add.cpp.md)(MTVector const & v2);

>MTVector [operator-](MTVector_add.cpp.md)(MTVector const & v2) const;

>MTVector [operator+](MTVector_add.cpp.md)(MTVector const & v2) const;

>MTVector& [add](MTVector_add.cpp.md)(MTVector const & v2);

>double [length](MTVector_length.cpp.md)() const;

>MTVector [differenceTo](MTVector_differenceTo.cpp.md)(MTVector const & v2) const;

>MTVector differenceTo(MTVector const * const v2) const { return differenceTo(*v2); }

>double [euklideanDistanceTo](MTVector_euklideanDistanceTo.cpp.md)(MTVector const & v2) const;

>MTVector& [normalize](MTVector_normalize.cpp.md)();

>MTVector& [scaleByScalar](MTVector_scaleByScalar.cpp.md)(double scalar);

>MTVector& [operator*=](MTVector_scaleByScalar.cpp.md)(double scalar);

>MTVector [operator*](MTVector_scaleByScalar.cpp.md)(double scalar) const;

>double [angleBetween](MTVector_angleBetween.cpp.md)(MTVector const & v2) const;

>double [scalarProductBy](MTVector_scalarProductBy.cpp.md)(MTVector const & v2) const;

>MTVector [vectorProductBy](MTVector_vectorProductBy.cpp.md)(MTVector const & v2) const;

>MTVector operator*(MTVector const & v2) const { return vectorProductBy(v2); }

>double [mixedProductBy](MTVector_mixedProductBy.cpp.md)(MTVector const & v2, MTVector const & v3);


##  /* creation */

>[MTVector](MTVector_ctor.cpp.md)(MTVector const &);

>explicit [MTVector](MTVector_ctor.cpp.md)(int dim);

>virtual [~MTVector](MTVector_dtor.cpp.md)();

>MTVector & [operator=](MTVector_ctor.cpp.md)(MTVector const &);

protected:

>int _dims { -1 };

>double *_elements { nullptr };


private:

>MTVector() = delete;

~~~ { .cpp }
};

std::ostream & operator<<(std::ostream & o, MTVector const & v);

} // namespace
~~~


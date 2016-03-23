// ![UML diagram](http://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/CodiePP/libmoltalk/master/doc/UML/mtmatrixinterface.uml)
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

# class MTMatrixInterface

~~~ { .cpp }
    {
   	public:
~~~

##		/* info */

>virtual bool isTransposed() const = 0;

>virtual int cols() const = 0;

>virtual int rows() const = 0;

>virtual std::string toString() const = 0;

##		/* getter/setter */

>virtual double atRowCol(int row, int col) const = 0;

>virtual void atRowColValue(int row, int col, double v) = 0;

##		/* matrix operations */

>virtual void transpose() = 0;

/*
>virtual MTMatrixInterface x(MTMatrixInterface const & m2) const = 0;

>virtual MTMatrixInterface mmultiply(MTMatrixInterface const & m2) const = 0;

>virtual MTMatrixInterface msubtract(MTMatrixInterface const & m2) const = 0;

>virtual MTMatrixInterface madd(MTMatrixInterface const & m2) const = 0;
*/

>virtual void addScalar(double scal) = 0;

>virtual void multiplyByScalar(double scal) = 0;

##		/* creation */

>//explicit MTMatrixInterface(int rows, int cols) {};

>//MTMatrixInterface(MTMatrixInterface const & m) {};

>//MTMatrixInterface(std::string const & str) {};

>MTMatrixInterface() {};

>virtual ~MTMatrixInterface() {};

~~~ { .cpp }
};

} // namespace
~~~

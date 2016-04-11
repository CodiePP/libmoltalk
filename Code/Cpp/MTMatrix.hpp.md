~~~ { .cpp }
/*
 *  Copyright 2016 by Alexander Diemand
 *
 *  [LICENSE](../../LICENSE)
 */

#pragma once

#include "MTMatrixInterface.hpp"

#include <string>
#include <iosfwd>

~~~

namespace [mt](namespace_mt.list) {

class MTMatrix53;

# class MTMatrix : public MTMatrixInterface

~~~ { .cpp }
    {
   	protected:
    		double *_elements {nullptr};
    		int _rows {0};
		int _cols {0};
    		bool _transposed {false};

   	public:
~~~

##		/* getter */

>virtual bool isTransposed() const override { return _transposed; }

>virtual int cols() const override { return _transposed?_rows:_cols; }

>virtual int rows() const override { return _transposed?_cols:_rows; }

>virtual std::string [toString](MTMatrix_toString.cpp.md)() const override;

>virtual double [atRowCol](MTMatrix_atRowCol.cpp.md)(int row, int col) const override;

>virtual MTMatrix [matrixOfColumn](MTMatrix_matrixOfColumn.cpp.md)(int col) const final;

>virtual void [linearizeTo](MTMatrix_linearizeTo.cpp.md)(double *mat, int count) const final; // write to array

##		/* setter */

>virtual void [atRowColValue](MTMatrix_atRowColValue.cpp.md)(int row, int col, double v) override;

##		/* matrix operations */

>virtual void [transpose](MTMatrix_transpose.cpp.md)() override;

>virtual MTMatrix [x](MTMatrix_x.cpp.md)(MTMatrix const & m2) const;

>virtual MTMatrix [mmultiply](MTMatrix_mmultiply.cpp.md)(MTMatrix const & m2) const;

>virtual MTMatrix [msubtract](MTMatrix_msubtract.cpp.md)(MTMatrix const & m2) const;

>virtual MTMatrix [madd](MTMatrix_madd.cpp.md)(MTMatrix const & m2) const;

>virtual void [addScalar](MTMatrix_addScalar.cpp.md)(double scal) override;

>virtual void subtractScalar(double scal) { addScalar( - scal); }

>virtual void [multiplyByScalar](MTMatrix_multiplyByScalar.cpp.md)(double scal) override;

>virtual void [divideByScalar](MTMatrix_divideByScalar.cpp.md)(double scal);

>virtual MTMatrix [diagonalizeWithMaxError](MTMatrix_diagonalizeWithMaxError.cpp.md)(double p_error) const final;

~~~ { .cpp }
#ifdef USE_GSL
~~~

>virtual MTMatrix [gslDiagonalizeWithMaxError](MTMatrix_gslDiagonalizeWithMaxError.cpp.md)(double p_error) const final;

~~~ { .cpp }
#endif
~~~

>virtual MTMatrix [jacobianDiagonalizeWithMaxError](MTMatrix_jacobianDiagonalizeWithMaxError.cpp.md)(double error) const final;

>virtual MTMatrix [centerOfMass](MTMatrix_centerOfMass.cpp.md)() const;

>virtual double [sum](MTMatrix_sum.cpp.md)() const;

>virtual void [square](MTMatrix_square.cpp.md)();

###		/* operations on single cells */

>virtual void [atRowColAdd](MTMatrix_atRowColAdd.cpp.md)(int row, int col, double v);

>virtual void atRowColSub(int row, int col, double v) { atRowColAdd(row,col,  - v); }

>virtual void [atRowColMult](MTMatrix_atRowColMult.cpp.md)(int row, int col, double v);

>virtual void [atRowColDiv](MTMatrix_atRowColDiv.cpp.md)(int rowm, int col, double v);


##		/* complex operations */

>[MTMatrix53](MTMatrix53.hpp.md) [alignTo](MTMatrix_alignTo.cpp.md)(MTMatrix const & m2);

##		/* creation */

>explicit [MTMatrix](MTMatrix_ctor.cpp.md)(int rows, int cols);

>[MTMatrix](MTMatrix_ctor.cpp.md)(MTMatrix const & m);

>[MTMatrix](MTMatrix_ctor.cpp.md)(std::string const & str);

>virtual [~MTMatrix](MTMatrix_dtor.cpp.md)();

>MTMatrix & [operator=](MTMatrix_ctor.cpp.md)(MTMatrix const & m);

## /* brewery */

>//[code header](MTMatrix_-alpha-.md)();

>//[code trailer](MTMatrix_-omega-.md)();


~~~ { .cpp }
};

std::ostream & operator<<(std::ostream &, MTMatrix const &);

} // namespace
~~~

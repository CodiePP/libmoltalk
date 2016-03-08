
<fpaste ../../LICENSE>

~~~ { .cpp }
#pragma once

#include "MTMatrixInterface.hpp"

#include <string>
#include <iosfwd>

~~~

namespace [mt](namespace_mt.list) {

//class MTMatrix53; // only needed for alignTo

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

>virtual std::string [toString](MTMatrix_toString.cpp)() const override;

>virtual double [atRowCol](MTMatrix_atRowCol.cpp)(int row, int col) const override;

>virtual MTMatrix [matrixOfColumn](MTMatrix_matrixOfColumn.cpp)(int col) const final;

>virtual void [linearizeTo](MTMatrix_linearizeTo.cpp)(double *mat, int count) const final; // write to array

##		/* setter */

>virtual void [atRowColValue](MTMatrix_atRowColValue.cpp)(int row, int col, double v) override;

##		/* matrix operations */

>virtual void [transpose](MTMatrix_transpose.cpp)() override;

>virtual MTMatrix [x](MTMatrix_x.cpp)(MTMatrix const & m2) const;

>virtual MTMatrix [mmultiply](MTMatrix_mmultiply.cpp)(MTMatrix const & m2) const;

>virtual MTMatrix [msubtract](MTMatrix_msubtract.cpp)(MTMatrix const & m2) const;

>virtual MTMatrix [madd](MTMatrix_madd.cpp)(MTMatrix const & m2) const;

>virtual void [addScalar](MTMatrix_addScalar.cpp)(double scal) override;

>virtual void subtractScalar(double scal) { addScalar( - scal); }

>virtual void [multiplyByScalar](MTMatrix_multiplyByScalar.cpp)(double scal) override;

>virtual void [divideByScalar](MTMatrix_divideByScalar.cpp)(double scal);

>virtual MTMatrix [diagonalizeWithMaxError](MTMatrix_diagonalizeWithMaxError.cpp)(double p_error) const final;

~~~ { .cpp }
#ifdef USE_GSL
~~~

>virtual MTMatrix [gslDiagonalizeWithMaxError](MTMatrix_gslDiagonalizeWithMaxError.cpp)(double p_error) const final;

~~~ { .cpp }
#endif
~~~

>virtual MTMatrix [jacobianDiagonalizeWithMaxError](MTMatrix_jacobianDiagonalizeWithMaxError.cpp)(double error) const final;

>virtual MTMatrix [centerOfMass](MTMatrix_centerOfMass.cpp)() const;

>virtual double [sum](MTMatrix_sum.cpp)() const;

>virtual void [square](MTMatrix_square.cpp)();

###		/* operations on single cells */

>virtual void [atRowColAdd](MTMatrix_atRowColAdd.cpp)(int row, int col, double v);

>virtual void atRowColSub(int row, int col, double v) { atRowColAdd(row,col,  - v); }

>virtual void [atRowColMult](MTMatrix_atRowColMult.cpp)(int row, int col, double v);

>virtual void [atRowColDiv](MTMatrix_atRowColDiv.cpp)(int rowm, int col, double v);


##		/* complex operations */

//>[MTMatrix53](MTMatrix53.hpp) [alignTo](MTMatrix_alignTo.cpp)(MTMatrix const & m2) const;

##		/* creation */

>explicit [MTMatrix](MTMatrix_ctor.cpp)(int rows, int cols);

>[MTMatrix](MTMatrix_ctor.cpp)(MTMatrix const & m);

>[MTMatrix](MTMatrix_ctor.cpp)(std::string const & str);

>virtual [~MTMatrix](MTMatrix_dtor.cpp)();

>MTMatrix & [operator=](MTMatrix_ctor.cpp)(MTMatrix const & m);

## /* brewery */

>//[code header](MTMatrix_-alpha-)();

>//[code trailer](MTMatrix_-omega-)();


~~~ { .cpp }
};

std::ostream & operator<<(std::ostream &, MTMatrix const &);

} // namespace
~~~


~~~ { .cpp }

#include "MTMatrix.hpp"
//#include "MTMatrix53.hpp"
#include <iostream>
#include <cstring>

#include "boost/format.hpp"

namespace mt {


int calcIndexForRowCol(MTMatrix const & m, int row, int col)
{
  if (m.isTransposed()) {
	if (row >= m.cols()) { throw "wrong row"; }
	if (col >= m.rows()) { throw "wrong col"; }
	return m.cols() * col + row;
  } else {
	if (col >= m.cols()) { throw "wrong col"; }
	if (row >= m.rows()) { throw "wrong row"; }
	return m.cols() * row + col;
  }
  return -1;
}


~~~


declared in [MTMatrix](MTMatrix.hpp.md)

TODO :exclamation:

~~~ { .cpp }
MTMatrix MTMatrix::centerOfMass() const
{
	auto m = MTMatrix(1,cols());
	int nrows = rows();
	int ncols = cols();
	for (int r=0; r<nrows; r++) {
		for (int c=0; c<ncols; c++) {
			m.atRowColAdd(0,c, atRowCol(r,c));
		}
	}
	for (int c=0; c<ncols; c++) {
		m.atRowColDiv(0,c, nrows);
	}
	return m;
}
~~~



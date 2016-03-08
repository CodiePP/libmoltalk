
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
void MTMatrix::atRowColMult(int row, int col, double v)
{
	atRowColValue(row, col, atRowCol(row, col) * v);
}
~~~


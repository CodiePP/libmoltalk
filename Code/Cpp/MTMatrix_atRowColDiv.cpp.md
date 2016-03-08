
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
void MTMatrix::atRowColDiv(int row, int col, double v)
{
	if (v == 0.0) { throw "cannot divide cell value by zero!"; }
	atRowColValue(row, col, atRowCol(row,col) / v);
}
~~~


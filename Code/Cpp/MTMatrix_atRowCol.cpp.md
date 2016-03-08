
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
double MTMatrix::atRowCol(int row, int col) const
{
	if (! _elements) { throw "empty!"; }
	int idx = calcIndexForRowCol(*this, row, col);
	if (idx >= 0) { return _elements[idx]; }
	throw "index out of bounds";
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   get value at row/col
 */
-(double)atRow:(int)row col:(int)col
{
	int idx = [self calcIndexForRow: row col: col];
	return elements[idx];
}
~~~

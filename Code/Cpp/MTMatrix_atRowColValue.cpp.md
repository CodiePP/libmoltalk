
declared in [MTMatrix](MTMatrix.hpp.md)

~~~ { .cpp }
void MTMatrix::atRowColValue(int row, int col, double v)
{
  int idx = calcIndexForRowCol(*this, row, col);
  if (idx >= 0) {
     _elements[idx] = v; }
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   set value at row/col
 */
-(id)atRow:(int)row col:(int)col value:(double)val
{
	int idx = [self calcIndexForRow: row col: col];
	elements[idx] = val;
	return self;
}
~~~

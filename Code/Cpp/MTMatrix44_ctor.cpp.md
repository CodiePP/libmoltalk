
declared in [MTMatrix44](MTMatrix44.hpp.md)

~~~ { .cpp }
MTMatrix44::MTMatrix44(std::string const & m)
	: MTMatrix(4,4)
{
	double t[4*4];
	sscanf(m.c_str(), " [ [ %lf , %lf , %lf , %lf ]  [ %lf , %lf , %lf , %lf ]  [ %lf , %lf , %lf , %lf ]  [ %lf , %lf , %lf , %lf ] ] ", 
		t, t+1, t+2, t+3, t+4, t+5, t+6, t+7,
		t+8, t+9, t+10, t+11, t+12, t+13, t+14, t+15);
}
~~~

~~~ { .cpp }
MTMatrix44::MTMatrix44(MTMatrix const & m)
	: MTMatrix(4,4)
{ 
	for (int irow = 0; irow < 4; irow++) {
		for (int icol = 0; icol < 4; icol++) {
			atRowColValue(irow,icol, m.atRowCol(irow,icol)); } }
}

MTMatrix44::MTMatrix44()
	: MTMatrix(4,4)
{
	atRowColValue(0,0, 1.0);
	atRowColValue(1,1, 1.0);
	atRowColValue(2,2, 1.0);
	atRowColValue(3,3, 1.0);
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   read and initializes a matrix from a string
 */
+(MTMatrix44*)matrixFromString:(NSString*)str
{
        MTMatrix44 *res = [MTMatrix44 new];
        NSScanner *sc = [NSScanner scannerWithString: str];
        [sc  setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString: @"[]         ,"]];
        double val;
        int irow,icol;
        for (irow=0; irow<4; irow++)
        {
                for (icol=0; icol<4; icol++)
                {
                        if (![sc scanDouble: &val])
                        {
                                NSLog(@"scan failed.");
                                return nil;
                        }
                        [res atRow: irow col: icol value: val];
                } /* icol */
        } /* irow */
        return AUTORELEASE(res);
}
~~~

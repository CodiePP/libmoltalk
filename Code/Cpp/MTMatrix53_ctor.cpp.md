
declared in [MTMatrix53](MTMatrix53.hpp.md)

TODO  :exclamation:

~~~ { .cpp }
MTMatrix53::MTMatrix53()
: MTMatrix(5,3)
{
  atRowColValue(0,0,1.0);
  atRowColValue(1,1,1.0);
  atRowColValue(2,2,1.0);
}

MTMatrix53::MTMatrix53(std::string const & m)
: MTMatrix(5,3)
{
    // todo
}
~~~


original objc code:

~~~ { .ObjectiveC }

        [super setRows:5 cols:3];
        [self atRow: 0 col: 0 value: 1.0];
        [self atRow: 1 col: 1 value: 1.0];
        [self atRow: 2 col: 2 value: 1.0];

/*
 *   reads and initializes a matrix from a string
 */
+(MTMatrix53*)matrixFromString:(NSString*)str
{
/* a matrix might look like this: 
 [ [-0.506316,0.559328,0.656350] [-0.607832,-0.771377,0.188463] [0.611706,-0.303529,0.730538] [62.893028,10.183025,-0.708629] [19.371693,40.109528,10.753658] ]
*/
        MTMatrix53 *res = [MTMatrix53 new];
        NSScanner *sc = [NSScanner scannerWithString: str];
        [sc  setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString: @"[] 
        ,"]];
        double val;
        int irow,icol;
        for (irow=0; irow<5; irow++)
        {
                for (icol=0; icol<3; icol++)
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

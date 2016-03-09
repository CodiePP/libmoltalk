
declared in [MTMatrix53](MTMatrix53.hpp.md)

TODO  :exclamation:

~~~ { .cpp }
MTMatrix53 MTMatrix53::withRotation(MTMatrix44 const & rot, MTCoordinates const & origin, MTCoordinates const & translation)
{
  return MTMatrix53();
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   create new Matrix53 from rotation, origin, and translation
 */
+(MTMatrix53*)withRotation:(MTMatrix44*)rot origin:(MTCoordinates*)orig translation:(MTCoordinates*)trans
{
        MTMatrix53 *m = [MTMatrix53 matrixIdentity];
        short i,j;
        for (i=0; i<3; i++)
        {
                for (j=0; j<3; j++)
                {
                        [m atRow: i col: j value: [rot atRow: i col: j]];
                }
                [m atRow: 3 col: i value: [orig atDim: i]];
                [m atRow: 4 col: i value: [trans atDim: i]];
        }
        return m;
}
~~~

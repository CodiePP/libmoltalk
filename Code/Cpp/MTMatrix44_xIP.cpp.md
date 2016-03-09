
declared in [MTMatrix44](MTMatrix44.hpp.md)

>   multiplies in-place (M' = M * p_M) with the parameter matrix

~~~ { .cpp }
void MTMatrix44::xIP(MTMatrix44 const & p_mat)
{
        double t[4][4];
        double vrow[4];
        double tsum=0.0;
        int irow,icol,tc;
        /* calculate temporary matrix */
        for (irow=0; irow<4; irow++)
        {
                vrow[0]=atRowCol(irow, 0);
                vrow[1]=atRowCol(irow, 1);
                vrow[2]=atRowCol(irow, 2);
                vrow[3]=atRowCol(irow, 3);
                for (icol=0; icol<4; icol++)
                {
                        tsum = 0.0;
                        for (tc=0; tc<4; tc++)
                        {
                                tsum += vrow[tc] * p_mat.atRowCol(tc, icol);
                        }
                        t[irow][icol] = tsum;
                }
        }
        /* copy from temporary to real matrix */
        for (irow=0; irow<4; irow++)
        {
                for (icol=0; icol<4; icol++)
                {
                        atRowColValue(irow, icol, t[irow][icol]);
                }
        }
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   multiplies in-place (M' = M * p_M) with the parameter matrix
 */
-(MTMatrix44*)xIP:(MTMatrix44*)p_mat
{
        double t[4][4];
        double vrow[4];
        double tsum=0.0;
        int irow,icol,tc;
        /* calculate temporary matrix */
        for (irow=0; irow<4; irow++)
        {
                vrow[0]=[self atRow:irow col:0];
                vrow[1]=[self atRow:irow col:1];
                vrow[2]=[self atRow:irow col:2];
                vrow[3]=[self atRow:irow col:3];
                for (icol=0; icol<4; icol++)
                {
                        tsum = 0.0;
                        for (tc=0; tc<4; tc++)
                        {
                                tsum += vrow[tc] * [p_mat atRow:tc col:icol];
                        }
                        t[irow][icol] = tsum;
                }
        }
        /* copy from temporary to real matrix */
        for (irow=0; irow<4; irow++)
        {
                for (icol=0; icol<4; icol++)
                {
                        [self atRow:irow col:icol value:t[irow][icol]];
                }
        }
        return self;

~~~


declared in [MTMatrix44](MTMatrix44.hpp.md)

~~~ { .cpp }
/*
 *   multiplies in-place (M' = p_M * M) with the parameter matrix
 */
void MTMatrix44::chainWith(MTMatrix44 const & p_mat)
{
        double t[4][4];
        double vrow[4];
        double tsum=0.0;
        int irow,icol,tc;
        /* calculate temporary matrix */
        for (irow=0; irow<4; irow++)
        {
                vrow[0]=p_mat.atRowCol(irow, 0);
                vrow[1]=p_mat.atRowCol(irow, 1);
                vrow[2]=p_mat.atRowCol(irow, 2);
                vrow[3]=p_mat.atRowCol(irow, 3);
                for (icol=0; icol<4; icol++)
                {
                        tsum = 0.0;
                        for (tc=0; tc<4; tc++)
                        {
                                tsum += vrow[tc] * atRowCol(tc, icol);
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
 *   multiplies in-place (M' = p_M * M) with the parameter matrix
 */
-(MTMatrix44*)chainWith:(MTMatrix44*)p_mat
{
        double t[4][4];
        double vrow[4];
        double tsum=0.0;
        int irow,icol,tc;
        /* calculate temporary matrix */
        for (irow=0; irow<4; irow++)
        {
                vrow[0]=[p_mat atRow:irow col:0];
                vrow[1]=[p_mat atRow:irow col:1];
                vrow[2]=[p_mat atRow:irow col:2];
                vrow[3]=[p_mat atRow:irow col:3];
                for (icol=0; icol<4; icol++)
                {
                        tsum = 0.0;
                        for (tc=0; tc<4; tc++)
                        {
                                tsum += vrow[tc] * [self atRow:tc col:icol];
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
}
~~~

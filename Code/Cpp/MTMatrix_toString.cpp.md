
declared in [MTMatrix](MTMatrix.hpp.md)

TODO :exclamation:

~~~ { .cpp }
std::string MTMatrix::toString() const
{
        char sbuffer[512];
	const int clen = 64;
        char tbuf[clen];
        int idx=0;
        
        memset(sbuffer,0,512);
        sbuffer[idx++]='[';
        int icol,irow;
        for (irow=0; irow<rows(); irow++)
        {
                sbuffer[idx++]='[';
                for (icol=0; icol<cols(); icol++)
                {
                        if (idx>=500)
                        {
				sbuffer[idx++]='.';
				sbuffer[idx++]='.';
				sbuffer[idx++]='.';
                                break;
                        }
                        if (icol > 0)
                        {
                                sbuffer[idx++]=',';
                        }
                        int i = snprintf(sbuffer+idx,clen,"%-.5f", atRowCol(irow, icol));
			idx += i;
                } // icol
                sbuffer[idx++]=']';
                if (idx>=500)
                {
			sbuffer[idx++]='.';
			sbuffer[idx++]='.';
			sbuffer[idx++]='.';
                        break;
                }
        } // irow
        sbuffer[idx++]=']';
        return sbuffer;
}
~~~

original objc code:

~~~ { .ObjectiveC }
/*
 *   returns a string representing this matrix.<br>
 *   rows are put between '[' and ']', where each column is seperated by ','<br>
 *   all rows are put between '[' and ']'.<br>
 *   thus a 3x2 matrix becomes: [[0,1][2,9],[-1,0]]"
 */
-(NSString*)toString
{
        //NSString *res = [NSString stringWithFormat: @"Matrix %dx%d",[self rows],[self cols]];

        char sbuffer[512];
        char tbuf[10];
        int idx=0;
        NSString *res = nil;
        
        memset(sbuffer,0,512);
        sbuffer[idx]='['; idx++;
        int icol,irow;
        for (irow=0; irow<[self rows]; irow++)
        {
                sbuffer[idx]='['; idx++;
                for (icol=0; icol<[self cols]; icol++)
                {
                        if (idx>=500)
                        {
                                break;
                        }
                        if (icol == 0)
                        {
                                snprintf(tbuf,10,"%4.5f",[self atRow: irow col: icol]);
                        } else {
                                snprintf(tbuf,10,",%4.5f",[self atRow: irow col: icol]);
                        }
                        int i=0;
                        while ((i<10) && (tbuf[i]!='\0'))
                        {
                                sbuffer[idx] = tbuf[i];
                                i++; idx++;
                        }
                } // icol
                sbuffer[idx]=']'; idx++;
                if (idx>=500)
                {
                        break;
                }
        } // irow
        sbuffer[idx]=']'; idx++;
        sbuffer[idx]='\0';
        res = [NSString stringWithCString: sbuffer];
        return res;
}

~~~


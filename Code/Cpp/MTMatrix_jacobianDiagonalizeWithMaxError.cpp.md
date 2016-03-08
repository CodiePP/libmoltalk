
declared in [MTMatrix](MTMatrix.hpp.md)

TODO: verify with real-world example  :exclamation:

~~~ { .cpp }
MTMatrix MTMatrix::jacobianDiagonalizeWithMaxError(double e) const
{
	bool running=true;
        const int allindex = _rows;
	auto fidx = [allindex](int r, int c)->int { return allindex * r + c; };
        if (_cols != allindex)
        {
                throw "MTMatrix: Jacobian diagonalization only works on square matrices.";
        }

        /* make copy of matrix */
	int idx;
        int irow,icol;
        double *mat = new double[allindex*allindex];
        for (idx=0; idx<allindex*allindex; idx++) {
		mat[idx] = _elements[idx];
	}
        double *eigen = new double[allindex*allindex];
        double lastsum=1e200;
        for (irow=0; irow<allindex; irow++) {
		for (icol=0; icol<allindex; icol++) {
			eigen[fidx(irow,icol)] = 0.0; // off-diagonal element
		}
                eigen[fidx(irow,irow)] = 1.0; // diagonal element
        }

        int p,q;
        int i;
        double theta,c,g,h;
        double r;
        double s;
        double t;
        
	double e_sq = (e*e);
        double t_sum;
        int iteration = 0;
        while (running)
        {
                iteration++;
                /* test for convergence */
                t_sum = 0.0;
                for (irow=1; irow<allindex; irow++)
                {
                        for (icol=0; icol<irow; icol++)
                        {
                                if (icol != irow)
                                {
                                        t_sum += (mat[fidx(irow,icol)] * mat[fidx(irow,icol)]);
                                }
                        }
                }
                std::clog << (boost::format("iteration: %d  t_sum=%4.2e") % iteration % t_sum).str() << std::endl;
                t_sum += t_sum;
                if (!finite(t_sum) || lastsum <= t_sum)
                {
                        std::clog << (boost::format("MTMatrix_jacobianDiagonalizeWithMaxError: Abort! after iteration: %d  t_sum=%4.2e") % iteration % t_sum).str() << std::endl;
                        running = false;
                        break;
                }
                lastsum = t_sum;
                if (t_sum <= e_sq)
                {
                        std::clog << (boost::format("MTMatrix_jacobianDiagonalizeWithMaxError: Converged! after iteration: %d  t_sum=%4.2e") % iteration % t_sum).str() << std::endl;
                        running = false;
                        break;
                }
                for (p=0; p<(allindex-1); p++) /* all columns */
                {
                        for (q=p+1; q<allindex; q++) /* all rows below column ( = lower triangle) */
                        {
                                //printf("p=%d q=%d\n",p,q);
                                if ((mat[fidx(q,p)] >=  e)
                                 || (mat[fidx(q,p)] <= -e))
                                {
                                        theta = (mat[fidx(q,q)] - mat[fidx(p,p)])/2.0/mat[fidx(q,p)];
                                        //printf("theta: %4.2e\n",theta);
                                        if (!finite(theta) || theta==0.0)
                                        {
                                                t = 1.0; /* tan(phi) */
                                        } else {
                                                if (theta>0.0)
                                                {
                                                        t = 1.0/(theta + sqrt(theta*theta+1.0));
                                                } else {
                                                        t = 1.0/(theta - sqrt(theta*theta+1.0));
                                                }
                                        }
                                        c = 1.0/sqrt(1.0+t*t); /* cosine */
                                        s = c*t; /* sine */
                                        r = s/(1.0+c); /* = tan(phi/2) */
                                        mat[fidx(p,p)] = mat[fidx(p,p)] - t*mat[fidx(q,p)];
                                        mat[fidx(q,q)] = mat[fidx(q,q)] + t*mat[fidx(q,p)];
                                        mat[fidx(q,p)] = 0.0; /* that's why we rotated the matrix */
                                        for (i=0; i<p; i++)
                                        {
                                                g = mat[fidx(q,i)] + r*mat[fidx(p,i)];
                                                h = mat[fidx(p,i)] - r*mat[fidx(q,i)];
                                                mat[fidx(p,i)] = mat[fidx(p,i)] - s*g;
                                                mat[fidx(q,i)] = mat[fidx(q,i)] + s*h;
                                        }
                                        for (i=p+1;i<q;i++)
                                        {
                                                g = mat[fidx(q,i)] + r*mat[fidx(i,p)];
                                                h = mat[fidx(i,p)] - r*mat[fidx(q,i)];
                                                mat[fidx(i,p)] = mat[fidx(i,p)] - s*g;
                                                mat[fidx(q,i)] = mat[fidx(q,i)] + s*h;
                                        }
                                        for (i=q+1; i<allindex; i++)
                                        {
                                                g = mat[fidx(i,q)] + r*mat[fidx(i,p)];
                                                h = mat[fidx(i,p)] - r*mat[fidx(i,q)];
                                                mat[fidx(i,p)] = mat[fidx(i,p)] - s*g;
                                                mat[fidx(i,q)] = mat[fidx(i,q)] + s*h;
                                        }
                                        for (i=0; i<allindex; i++)
                                        {
                                                g = eigen[fidx(i,q)] + r*eigen[fidx(i,p)];
                                                h = eigen[fidx(i,p)] - r*eigen[fidx(i,q)];
                                                eigen[fidx(i,p)] = eigen[fidx(i,p)] - s*g;
                                                eigen[fidx(i,q)] = eigen[fidx(i,q)] + s*h;
                                        }
                                }
                        }
                }
                /* debug output */
                /*
                for (irow=0; irow<allindex; irow++)
                {
                        for (icol=0; icol<allindex; icol++)
                        {
                                printf("%4.2f ", mat[fidx(irow,icol)]);
                        }
                        printf("\n");
                }
                */
        } /* while running */

        /* debug */
        /*
        for (irow=0; irow<allindex; irow++)
        {
                for (icol=0; icol<allindex; icol++)
                {
                        printf("%4.2f ", mat[fidx(irow,icol)]);
                }
                printf("\n");
        }
        */
        /* output */
        auto result = MTMatrix((allindex+1), allindex);
        for (irow=0; irow<allindex; irow++)
        {
                for (icol=0; icol<allindex; icol++)
                {
                        result.atRowColValue((irow+1), icol, eigen[fidx(irow,icol)]); /* eigenvectors */
                }
                result.atRowColValue(0, irow, mat[fidx(irow,irow)]); /* eigenvalues */
        }
        
        /* release temps */
        delete[] eigen;
        delete[] mat;

        return result;
}
~~~


original objc code:

~~~ { .ObjectiveC }
-(MTMatrix*)jacobianDiagonalizeWithMaxError: (double)p_error
{
        BOOL running=YES;
        int allindex = [self rows];
        if ([self cols] != allindex)
        {
                NSLog(@"MTMatrix: Jacobian diagonalization only works on square matrices.");
                return nil;
        }

        /* make copy of matrix */
        MTMatrix *result = nil;
        double **mat;
        double **eigen = allocatedoublematrix(allindex,allindex);
        double lastsum=1e200;
        int irow,icol;
        mat = [self cValues];
        for (irow=0; irow<allindex; irow++)
        {
                eigen[irow][irow] = 1.0;
        }

        int p,q;
        int i;
        double theta,c,g,h;
        double r;
        double s;
        double t;
        
        double t_sum;
        int iteration = 0;
        while (running)
        {
                iteration++;
                /* test for convergence */
                t_sum = 0.0;
                for (irow=1; irow<allindex; irow++)
                {
                        for (icol=0; icol<irow; icol++)
                        {
                                if (icol != irow)
                                {
                                        t_sum += (mat[irow][icol] * mat[irow][icol]);
                                }
                        }
                }
                //printf("iteration: %d  t_sum=%4.2e\n",iteration,t_sum);
                t_sum += t_sum;
                if (!finite(t_sum) || lastsum <= t_sum)
                {
                        //NSDebugLLog(@"MTMatrix_jacobianDiagonalizeWithMaxError:", @"Abort! after iteration: %d  t_sum=%4.2e",iteration,t_sum);
                        running = NO;
                        break;
                }
                lastsum = t_sum;
                if (t_sum <= (p_error*p_error))
                {
                        //NSDebugLLog(@"MTMatrix_jacobianDiagonalizeWithMaxError:", @"Converged! after iteration: %d  t_sum=%4.2e\n",iteration,t_sum);
                        running = NO;
                        break;
                }
                for (p=0; p<(allindex-1); p++) /* all columns */
                {
                        for (q=p+1; q<allindex; q++) /* all rows below column ( = lower triangle) */
                        {
                                //printf("p=%d q=%d\n",p,q);
                                if ((mat[q][p] >= p_error)
                                || (mat[q][p] <= -p_error))
                                {
                                        theta = (mat[q][q] - mat[p][p])/2.0/mat[q][p];
                                        //printf("theta: %4.2e\n",theta);
                                        if (!finite(theta) || theta==0.0)
                                        {
                                                t = 1.0; /* tan(phi) */
                                        } else {
                                                if (theta>0.0)
                                                {
                                                        t = 1.0/(theta + sqrt(theta*theta+1.0));
                                                } else {
                                                        t = 1.0/(theta - sqrt(theta*theta+1.0));
                                                }
                                        }
                                        c = 1.0/sqrt(1.0+t*t); /* cosine */
                                        s = c*t; /* sine */
                                        r = s/(1.0+c); /* = tan(phi/2) */
                                        mat[p][p] = mat[p][p] - t*mat[q][p];
                                        mat[q][q] = mat[q][q] + t*mat[q][p];
                                        mat[q][p] = 0.0; /* that's why we rotated the matrix */
                                        for (i=0; i<p; i++)
                                        {
                                                g = mat[q][i] + r*mat[p][i];
                                                h = mat[p][i] - r*mat[q][i];
                                                mat[p][i] = mat[p][i] - s*g;
                                                mat[q][i] = mat[q][i] + s*h;
                                        }
                                        for (i=p+1;i<q;i++)
                                        {
                                                g = mat[q][i] + r*mat[i][p];
                                                h = mat[i][p] - r*mat[q][i];
                                                mat[i][p] = mat[i][p] - s*g;
                                                mat[q][i] = mat[q][i] + s*h;
                                        }
                                        for (i=q+1; i<allindex; i++)
                                        {
                                                g = mat[i][q] + r*mat[i][p];
                                                h = mat[i][p] - r*mat[i][q];
                                                mat[i][p] = mat[i][p] - s*g;
                                                mat[i][q] = mat[i][q] + s*h;
                                        }
                                        for (i=0; i<allindex; i++)
                                        {
                                                g = eigen[i][q] + r*eigen[i][p];
                                                h = eigen[i][p] - r*eigen[i][q];
                                                eigen[i][p] = eigen[i][p] - s*g;
                                                eigen[i][q] = eigen[i][q] + s*h;
                                        }
                                }
                        }
                }
               /* debug output */
                /*
                for (irow=0; irow<allindex; irow++)
                {
                        for (icol=0; icol<allindex; icol++)
                        {
                                printf("%4.2f ", mat[irow][icol]);
                        }
                        printf("\n");
                }
                */
        } /* while running */

        /* debug */
        /*
        for (irow=0; irow<allindex; irow++)
        {
                for (icol=0; icol<allindex; icol++)
                {
                        printf("%4.2f ", mat[irow][icol]);
                }
                printf("\n");
        }
        */
        /* output */
        result = [MTMatrix matrixWithRows: (allindex+1) cols: allindex];
        for (irow=0; irow<allindex; irow++)
        {
                for (icol=0; icol<allindex; icol++)
                {
                        [result atRow: (irow+1) col: icol value: eigen[irow][icol]]; /* eigenvectors */
                }
                [result atRow: 0 col: irow value: mat[irow][irow]]; /* eigenvalues */
        }
        
        /* release temps */
        for (irow=0; irow<allindex; irow++)
        {
                objc_free(eigen[irow]);
                objc_free(mat[irow]);
        }
        objc_free(eigen);
        objc_free(mat);

        return result;
}

~~~

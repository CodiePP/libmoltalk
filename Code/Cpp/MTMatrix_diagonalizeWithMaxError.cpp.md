
declared in [MTMatrix](MTMatrix.hpp.md)

TODO: add and test the gsl.. calculation  :exclamation:

>   diagonalize a symmetric nxn matrix
>   returns a matrix with the eigenvectors in rows: 1-n, eigenvalues in row 0

~~~ { .cpp }
MTMatrix MTMatrix::diagonalizeWithMaxError(double e) const
{
#ifdef USE_GSL
        return gslDiagonalizeWithMaxError(e);
#else
        return jacobianDiagonalizeWithMaxError(e);
#endif
}
~~~


original objc code:

~~~ { .ObjectiveC }
/*
 *   diagonalize a symmetric nxn matrix
 *   returns a matrix with the eigenvectors in rows: 1-n, eigenvalues in row 0
 */
-(MTMatrix*)diagonalizeWithMaxError: (double)p_error
{
#ifdef USE_GSL
        return [self gslDiagonalizeWithMaxError:p_error];
#else
        return [self jacobianDiagonalizeWithMaxError:p_error];
#endif
}
~~~

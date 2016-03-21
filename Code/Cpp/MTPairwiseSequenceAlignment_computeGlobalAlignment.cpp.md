
declared in [MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment.hpp.md)

~~~ { .cpp }

#define VERBOSE_TRACEBACK

void MTPairwiseSequenceAlignment::computeGlobalAlignment()
{
	float f_gop = _pimpl->_gop;
	float f_gep = _pimpl->_gep;
	float *scorematrix;
	float *hinsert, *vinsert;
	int *tbmatrix;
	int len1, len2;
	int row,col,i,j,dir;
	float score, h1,h2,h3,tval;
	std::list<MTResidue*> lres;
	std::vector<MTResidue*> residues1;
	std::vector<MTResidue*> residues2;

	_pimpl->_positions = {};

	/* prepare sequence 1 and 2 */
	if (_pimpl->_chain1) {
		lres = _pimpl->_chain1->filterResidues([](MTResidue* r)->bool { return r->isStandardAminoAcid(); });
		residues1 = std::vector<MTResidue*>(lres.begin(), lres.end());
		_pimpl->_seq1 = _pimpl->_chain1->get3DSequence(); }
	len1 = _pimpl->_seq1.size()+1;

	if (_pimpl->_chain2) {
		lres = _pimpl->_chain2->filterResidues([](MTResidue* r)->bool { return r->isStandardAminoAcid(); });
		residues2 = std::vector<MTResidue*>(lres.begin(), lres.end());
		_pimpl->_seq2 = _pimpl->_chain2->get3DSequence(); }
	len2 = _pimpl->_seq2.size()+2;
	lres = {};

	scorematrix = (float*)calloc((len1)*(len2),sizeof(float));
	vinsert = (float*)calloc((len1)*(len2),sizeof(float));
	hinsert = (float*)calloc((len1)*(len2),sizeof(float));
	tbmatrix = (int*)calloc((len1)*(len2),sizeof(int));	
	
	if (! (scorematrix && vinsert && hinsert && tbmatrix))
	{
		std::clog << "failed to allocate scoring matrix." << std::endl;
		return;
	}

	/* prepare scoring matrix */
//#define LOWERBOUND FLT_MIN
#define LOWERBOUND -999.0f
	for (row=1; row<len2; row++)
	{
		vinsert[row*len1] = -f_gop - f_gep * (row-1); // first column
		hinsert[row*len1] = LOWERBOUND;
		scorematrix[row*len1] = LOWERBOUND;
	}
	for (col=1; col<len1; col++)
	{
		hinsert[col] = -f_gop - f_gep * col; // first row
		vinsert[col] = LOWERBOUND;
		scorematrix[col] = LOWERBOUND;
	}
	
	dir=0; // direction of transition: -1==down, 1==right, 2==diagonal, 0==end of alignment
	for (col=1; col<len1; col++)
	{
		for (row=1; row<len2; row++)
		{
			score = _pimpl->_substm->scoreBetween(_pimpl->_seq1[col-1], _pimpl->_seq2[row-1]);
			h1 = scorematrix[(row-1)*len1+(col-1)] + score; // diagonal element
			h2 = hinsert[(row-1)*len1+(col-1)] + score; // end of gap horizontal
			h3 = vinsert[(row-1)*len1+(col-1)] + score; // end of gap vertical
			score = h1;
			dir = 2;
			if (h3>score) {
				score = h3;
				dir = -1; // vertical
			}
			if (h2>score) {
				score = h2;
				dir = 1; // horizontal
			}
			scorematrix[(row)*len1+(col)] = score; // save maximum value in matrix
			tbmatrix[(row)*len1+(col)] = dir; // save traceback direction
			
			// update insertion matrices
			score = scorematrix[row*len1+(col-1)] - f_gop;
			tval = hinsert[row*len1+(col-1)] - f_gep;
			hinsert[(row)*len1+(col)] = (score>tval?score:tval);
			score = scorematrix[(row-1)*len1+col] - f_gop;
			tval = vinsert[(row-1)*len1+col] - f_gep;
			vinsert[row*len1+(col)] = (score>tval?score:tval);
		} // all rows
	} // all columns

	/* find maximum in last i=col/j=row */
	i=0; 
	j=(len2-1)*len1; // start of last row
	score=0.0f;
	for (col=0; col<len1; col++)
	{
		tval = scorematrix[j+col];
		if (tval > score)
		{
			score = tval; i = col;
		}
	}
	j=-1;
	for (row=0; row<len2; row++)
	{
		tval = scorematrix[(row+1)*len1-1];  // last col
		if (tval >= score)
		{
			score = tval; j = row; i = -1;
		}
	}
	/* write score matrix to file */
#ifdef VERBOSE_TRACEBACK
	if (i < 0)
	{
		printf("maximum: %1.1f at row=%d of last col\n",score,j);
	} else {
		printf("maximum: %1.1f at col=%d of last row\n",score,i);
	}

	FILE *outfile = fopen("t_scores.csv","w");
	if (outfile)
	{
		fprintf(outfile,".           ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"    %c  ", _pimpl->_seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c    ", _pimpl->_seq2[row-1]);
			else fprintf(outfile,"     ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 6.1f ",scorematrix[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_hscores.csv","w");
	if (outfile)
	{
		fprintf(outfile,".           ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"    %c  ", _pimpl->_seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c    ", _pimpl->_seq2[row-1]);
			else fprintf(outfile,"     ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 6.1f ",hinsert[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_vscores.csv","w");
	if (outfile)
	{
		fprintf(outfile,".           ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"    %c  ", _pimpl->_seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c    ", _pimpl->_seq2[row-1]);
			else fprintf(outfile,"     ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 6.1f ",vinsert[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_tb.csv","w");
	if (outfile)
	{
		fprintf(outfile,".     ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"  %c ", _pimpl->_seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c ", _pimpl->_seq2[row-1]);
			else fprintf(outfile,"  ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 3d ",tbmatrix[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
#endif /* VERBOSE_TRACEBACK */


/*  T R A C E B A C K  */

	if (i >= 0) /* maximum in col i of last row */
	{
		for (dir = len1-1; dir > i; dir--)
		{
			_pimpl->_positions.push_back( MTAlPos(residues1[(dir-1)], nullptr) );
#ifdef VERBOSE_TRACEBACK
			printf("%c  -\n",_pimpl->_seq1[dir-1]);
#endif
		}
		j = len2-1;
	} else if (j >= 0) { /* maximum in row j of last column */ 
		for (dir = len2-1; dir > j; dir--)
		{
			
			_pimpl->_positions.push_back( MTAlPos( nullptr,  residues2[(dir-1)]) );
#ifdef VERBOSE_TRACEBACK
			printf("-  %c  %1.1f\n",_pimpl->_seq2[dir-1]);
#endif
		}
		i = len1-1;
	}
	dir = 2; // last match
	while ((i>0) && (j>0))
	{
#ifdef VERBOSE_TRACEBACK
		score = scorematrix[j*len1+i];
#endif
		if (dir == 2)
		{
#ifdef VERBOSE_TRACEBACK
			printf("%c  %c  %1.1f\n",_pimpl->_seq1[i-1],_pimpl->_seq2[j-1],score);
#endif
			_pimpl->_positions.push_back(MTAlPos(residues1[(i-1)], residues2[(j-1)]));
		} else if (dir == -1) { // gap in seq1 
#ifdef VERBOSE_TRACEBACK
			printf("-  %c\n",_pimpl->_seq2[j-1]);
#endif
			_pimpl->_positions.push_back(MTAlPos(nullptr, residues2[(j-1)]));
		} else if (dir == 1) { // gap in seq2 
#ifdef VERBOSE_TRACEBACK
			printf("%c  -\n",_pimpl->_seq1[i-1]);
#endif
			_pimpl->_positions.push_back(MTAlPos(residues1[(i-1)], nullptr));
		} else {
#ifdef VERBOSE_TRACEBACK
			printf("?  ?  %1.1f\n",score);
#endif
		}
		dir = tbmatrix[j*len1+i];
		if (dir == 2)
		{
			j--; i--;
		} else if (dir == -1) {
			j--;
		} else if (dir == 1) {
			i--;
		} else {
			printf("error in traceback at i=%d, j=%d\n",i,j);
			j--; i--;
		}
	}
	while (i>1)
	{
		i--;
#ifdef VERBOSE_TRACEBACK
		score = scorematrix[i];
		printf("%c  - \n",_pimpl->_seq1[i-1]);
#endif
		_pimpl->_positions.push_back(MTAlPos(residues1[(i-1)], nullptr));
	}
	while (j>1)
	{
		j--;
#ifdef VERBOSE_TRACEBACK
		score = scorematrix[j*len1];
		printf("-  %c\n",_pimpl->_seq2[j-1]);
#endif
		_pimpl->_positions.push_back(MTAlPos(nullptr, residues2[(j-1)]));
	}

	free (hinsert);
	free (vinsert);
	free (scorematrix);
	free (tbmatrix);

	_pimpl->_computed = true;
}
~~~

original objc code:

~~~ { .ObjectiveC }

/*
 *   compute the global (Needleman-Wunsch) alignment between the sequences of the two @class(MTChain) chains
 */
-(void)computeGlobalAlignment
{
	MTAlPos *alpos;
	float *scorematrix;
	float *hinsert, *vinsert;
	int *tbmatrix;
	const char *seq1, *seq2;
	int len1, len2;
	int row,col,i,j,dir;
	float score, h1,h2,h3,tval;
	NSMutableArray *residues1, *residues2;

#ifdef DEBUG_COMPUTING_TIME
	clock_t timebase1,timebase2;
	timebase1 = clock ();
#endif	

	CREATE_AUTORELEASE_POOL(pool);

	if (positions)
	{
		[positions removeAllObjects]; 
		RELEASE(positions); // get rid of old MTAlPos(itions)
		positions = nil;
	}
	positions = RETAIN([NSMutableArray arrayWithCapacity: 200]);
	
	/* prepare sequence 1 and 2 */
	seq1 = [[chain1 get3DSequence] cString];
	len1 = [chain1 countStandardAminoAcids]+1;
	seq2 = [[chain2 get3DSequence] cString];
	len2 = [chain2 countStandardAminoAcids]+1;
	residues1 = [NSMutableArray arrayWithCapacity: len1-1 ];
	residues2 = [NSMutableArray arrayWithCapacity: len2-1 ];

	MTResidue *tres;
	NSEnumerator *resenum = [chain1 allResidues];
	while ((tres = [resenum nextObject]))
	{
		if ([tres isStandardAminoAcid])
		{
			[residues1 addObject: tres];
		}
	}
	resenum = [chain2 allResidues];
	while ((tres = [resenum nextObject]))
	{
		if ([tres isStandardAminoAcid])
		{
			[residues2 addObject: tres];
		}
	}
	if ([residues1 count] != (len1 - 1))
	{
		NSLog(@"Not the same number of residues found in chain1 as in 3D sequence.");
		return;
	}
	if ([residues2 count] != (len2 - 1))
	{
		NSLog(@"Not the same number of residues found in chain2 as in 3D sequence.");
		return;
	}

	scorematrix = (float*)calloc((len1)*(len2),sizeof(float));
	vinsert = (float*)calloc((len1)*(len2),sizeof(float));
	hinsert = (float*)calloc((len1)*(len2),sizeof(float));
	tbmatrix = (int*)calloc((len1)*(len2),sizeof(int));	
	
	if (! (scorematrix && vinsert && hinsert && tbmatrix))
	{
		NSLog(@"failed to allocate scoring matrix.");
		RELEASE(pool);
		return;
	}

	/* prepare scoring matrix */
//#define LOWERBOUND -FLT_MAX
#define LOWERBOUND -999.0f
	for (row=1; row<len2; row++)
	{
		vinsert[row*len1] = -f_gop - f_gep * (row-1); // first column
		hinsert[row*len1] = LOWERBOUND;
		scorematrix[row*len1] = LOWERBOUND;
	}
	for (col=1; col<len1; col++)
	{
		hinsert[col] = -f_gop - f_gep * col; // first row
		vinsert[col] = LOWERBOUND;
		scorematrix[col] = LOWERBOUND;
	}
	
	dir=0; // direction of transition: -1==down, 1==right, 2==diagonal, 0==end of alignment
	for (col=1; col<len1; col++)
	{
		for (row=1; row<len2; row++)
		{
			score = [substitutionMatrix exchangeScoreBetween: seq1[col-1] and: seq2[row-1] ];
			//printf("%@ - %@ d:%2.2f h1=%2.2f\n",here,there,dist,h1);
			h1 = scorematrix[(row-1)*len1+(col-1)] + score; // diagonal element
			h2 = hinsert[(row-1)*len1+(col-1)] + score; // end of gap horizontal
			h3 = vinsert[(row-1)*len1+(col-1)] + score; // end of gap vertical
			score = h1;
			dir = 2;
			if (h3>score)
			{
				score = h3;
				dir = -1; // vertical
			}
			if (h2>score)
			{
				score = h2;
				dir = 1; // horizontal
			}
			//if (h1>=score)	// overwrite in case of same value
			//{
			//	score = h1;
			//	dir = 2;
			//}
			scorematrix[(row)*len1+(col)] = score; // save maximum value in matrix
			tbmatrix[(row)*len1+(col)] = dir; // save traceback direction
			
			// update insertion matrices
			score = scorematrix[row*len1+(col-1)] - f_gop;
			tval = hinsert[row*len1+(col-1)] - f_gep;
			hinsert[(row)*len1+(col)] = (score>tval?score:tval);
			score = scorematrix[(row-1)*len1+col] - f_gop;
			tval = vinsert[(row-1)*len1+col] - f_gep;
			vinsert[row*len1+(col)] = (score>tval?score:tval);
		} // all rows
	} // all columns

#ifdef DEBUG_COMPUTING_TIME
	timebase2 = clock ();
	printf("  time spent in forward : %1.1f ms\n",((timebase2-timebase1)*1000.0f/CLOCKS_PER_SEC));
	timebase1 = timebase2;
#endif

	/* find maximum in last i=col/j=row */
	i=0; 
	j=(len2-1)*len1; // start of last row
	score=0.0f;
	for (col=0; col<len1; col++)
	{
		tval = scorematrix[j+col];
		if (tval > score)
		{
			score = tval; i = col;
		}
	}
	j=-1;
	for (row=0; row<len2; row++)
	{
		tval = scorematrix[(row+1)*len1-1];  // last col
		if (tval >= score)
		{
			score = tval; j = row; i = -1;
		}
	}
	/* write score matrix to file */
#ifdef VERBOSE_TRACEBACK
	if (i < 0)
	{
		printf("maximum: %1.1f at row=%d of last col\n",score,j);
	} else {
		printf("maximum: %1.1f at col=%d of last row\n",score,i);
	}

	FILE *outfile = fopen("t_scores.csv","w");
	if (outfile)
	{
		fprintf(outfile,".           ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"    %c  ",seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c    ",seq2[row-1]);
			else fprintf(outfile,"     ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 6.1f ",scorematrix[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_hscores.csv","w");
	if (outfile)
	{
		fprintf(outfile,".           ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"    %c  ",seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c    ",seq2[row-1]);
			else fprintf(outfile,"     ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 6.1f ",hinsert[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_vscores.csv","w");
	if (outfile)
	{
		fprintf(outfile,".           ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"    %c  ",seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c    ",seq2[row-1]);
			else fprintf(outfile,"     ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 6.1f ",vinsert[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
	outfile = fopen("t_tb.csv","w");
	if (outfile)
	{
		fprintf(outfile,".     ");
		for (col=1; col<len1; col++)
		{
			fprintf(outfile,"  %c ",seq1[col-1]);
		}
		fprintf(outfile,"\n");
		for (row=0; row<len2; row++)
		{
			if (row > 0) fprintf(outfile,"%c ",seq2[row-1]);
			else fprintf(outfile,"  ");
			for (col=0; col<len1; col++)
			{
				fprintf(outfile,"% 3d ",tbmatrix[row*len1+col]);
			}
			fprintf(outfile,"\n");
		}
		fclose(outfile);
	}
#endif /* VERBOSE_TRACEBACK */


/*  T R A C E B A C K  */

	if (i >= 0) /* maximum in col i of last row */
	{
		for (dir = len1-1; dir > i; dir--)
		{
			alpos = [MTAlPos alposWithRes1: [residues1 objectAtIndex: (dir-1)] res2: nil];
			[positions addObject: alpos];
#ifdef VERBOSE_TRACEBACK
			printf("%c  -\n",seq1[dir-1]);
#endif
		}
		j = len2-1;
	} else if (j >= 0) { /* maximum in row j of last column */ 
		for (dir = len2-1; dir > j; dir--)
		{
			alpos = [MTAlPos alposWithRes1: nil res2: [residues2 objectAtIndex: (dir-1)]];
			[positions addObject: alpos];
#ifdef VERBOSE_TRACEBACK
			printf("-  %c  %1.1f\n",seq2[dir-1]);
#endif
		}
		i = len1-1;
	}
	dir = 2; // last match
	while ((i>0) && (j>0))
	{
#ifdef VERBOSE_TRACEBACK
		score = scorematrix[j*len1+i];
#endif
		if (dir == 2)
		{
#ifdef VERBOSE_TRACEBACK
			printf("%c  %c  %1.1f\n",seq1[i-1],seq2[j-1],score);
#endif
			alpos = [MTAlPos alposWithRes1: [residues1 objectAtIndex: (i-1)] res2: [residues2 objectAtIndex: (j-1)]];
		} else if (dir == -1) { // gap in seq1 
#ifdef VERBOSE_TRACEBACK
			printf("-  %c\n",seq2[j-1]);
#endif
			alpos = [MTAlPos alposWithRes1: nil res2: [residues2 objectAtIndex: (j-1)]];
		} else if (dir == 1) { // gap in seq2 
#ifdef VERBOSE_TRACEBACK
			printf("%c  -\n",seq1[i-1]);
#endif
			alpos = [MTAlPos alposWithRes1: [residues1 objectAtIndex: (i-1)] res2: nil];
		} else {
#ifdef VERBOSE_TRACEBACK
			printf("?  ?  %1.1f\n",score);
#endif
			alpos = nil;
		}
		if (alpos)
		{
			[positions addObject: alpos];
		}
		dir = tbmatrix[j*len1+i];
		if (dir == 2)
		{
			j--; i--;
		} else if (dir == -1) {
			j--;
		} else if (dir == 1) {
			i--;
		} else {
			printf("error in traceback at i=%d, j=%d\n",i,j);
			j--; i--;
		}
	}
	while (i>1)
	{
		i--;
#ifdef VERBOSE_TRACEBACK
		score = scorematrix[i];
		printf("%c  - \n",seq1[i-1]);
#endif
		alpos = [MTAlPos alposWithRes1: [residues1 objectAtIndex: (i-1)] res2: nil];
		[positions addObject: alpos];
	}
	while (j>1)
	{
		j--;
#ifdef VERBOSE_TRACEBACK
		score = scorematrix[j*len1];
		printf("-  %c\n",seq2[j-1]);
#endif
		alpos = [MTAlPos alposWithRes1: nil res2: [residues2 objectAtIndex: (j-1)]];
		[positions addObject: alpos];
	}

#ifdef DEBUG_COMPUTING_TIME
	timebase2 = clock ();
	printf("  time spent in traceback: %1.1f ms\n",((timebase2-timebase1)*1000.0f/CLOCKS_PER_SEC));
	timebase1 = timebase2;
#endif
	free (hinsert);
	free (vinsert);
	free (scorematrix);
	free (tbmatrix);

	computed = YES;

	RELEASE(pool);
}


~~~

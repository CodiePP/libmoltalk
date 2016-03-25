
declared in [MTPairwiseSequenceAlignment](MTPairwiseSequenceAlignment.hpp.md)

~~~ { .cpp }

const MTChain* MTPairwiseSequenceAlignment::chain1() const
{
	return _pimpl->_chain1;
}

const MTChain* MTPairwiseSequenceAlignment::chain2() const
{
	return _pimpl->_chain2;
}

std::string MTPairwiseSequenceAlignment::toString() const
{
	std::string s;
	MTResidue *r1, *r2;
	for (auto const & p : _pimpl->_positions) {
		r1 = p.residue1();
		r2 = p.residue2();
		if (r1) { s += r1->oneLetterCode(); }
		else    { s += "-"; }
		s += " ";
		if (r2) { s += r2->oneLetterCode(); }
		else    { s += "-"; }
		s += "\\n";
	}

	return s;
}

std::string MTPairwiseSequenceAlignment::toFasta() const
{
	return "";
}

int MTPairwiseSequenceAlignment::countAligned() const
{
	return 0;
}

int MTPairwiseSequenceAlignment::countIdentical() const
{
	return 0;
}

int MTPairwiseSequenceAlignment::countGapped() const
{
	return 0;
}

~~~


original objc code:

~~~ { .ObjectiveC }

-(NSString*)getSequence1
{
        int count=0;
        if (positions)
        {
                count = [positions count];
        }
        NSMutableString *msg = [NSMutableString string];
        int i;
        MTAlPos *alpos;
        for (i=count-1; i>=0; i--)
        {
                alpos = [positions objectAtIndex: i];
                if ([alpos res1])
                {
                        [msg appendString: [[alpos res1] oneLetterCode]];
                } else {
                        [msg appendString: @"-"];
                }
        }
        return msg;
}


-(NSString*)getSequence2
{
        int count=0;
        if (positions)
        {
                count = [positions count];
        }
        NSMutableString *msg = [NSMutableString string];
        int i;
        MTAlPos *alpos;
        for (i=count-1; i>=0; i--)
        {
                alpos = [positions objectAtIndex: i];
                if ([alpos res2])
                {
                        [msg appendString: [[alpos res2] oneLetterCode]];
                } else {
                        [msg appendString: @"-"];
                }
        }
        return msg;
}

-(int)countPairs
{
        if (!computed)
        {
                NSLog(@"MTPairwiseSequenceAlignment needs to be computed first.");
                return -1;
        }
        int count=0;
        if (positions)
        {
                count = [positions count];
        }
        return count;
}


-(int)countIdenticalPairs
{
        if (!computed)
        {
                NSLog(@"MTPairwiseSequenceAlignment needs to be computed first.");
                return -1;
        }
        int count = 0;
        int j;
        int i=[positions count];
        MTAlPos *alpos;
        for (j=1; j<=i; j++)
        {
                alpos = [positions objectAtIndex: (i-j)];
                if (![alpos isGapped])
                {
                        if ([[[alpos res1]oneLetterCode] isEqualToString: [[alpos res2]oneLetterCode]])
                        {
                                count++;
                        }
                }
        }
        return count;
}

-(int)countUngappedPairs
{
        if (!computed)
        {
                NSLog(@"MTPairwiseSequenceAlignment needs to be computed first.");
                return -1;
        }
        int count = 0;
        int j;
        int i=[positions count];
        MTAlPos *alpos;
        for (j=1; j<=i; j++)
        {
                alpos = [positions objectAtIndex: (i-j)];
                if (![alpos isGapped])
                {
                        count++;
                }
        }
        return count;
}

-(MTSelection*)getSelection1
{
        if (!computed)
        {
                [NSException raise:@"Unsupported" format:@"The alignment must first be computed."];
        }
        MTSelection *sel = [MTSelection selectionWithChain: chain1];
        int count=0;
        if (positions)
        {
                count = [positions count];
        }
        int i;
        MTAlPos *alpos;
        for (i=count-1; i>=0; i--)
        {
                alpos = [positions objectAtIndex: i];
                if (![alpos isGapped])
                {
                        [sel addResidue: [alpos res1]];
                }
        }
        return sel;
}


-(MTSelection*)getSelection2
{
        if (!computed)
        {
                [NSException raise:@"Unsupported" format:@"The alignment must first be computed."];
        }
        MTSelection *sel = [MTSelection selectionWithChain: chain2];
        int count=0;
        if (positions)
        {
                count = [positions count];
        }
        int i;
        MTAlPos *alpos;
        for (i=count-1; i>=0; i--)
        {
                alpos = [positions objectAtIndex: i];
                if (![alpos isGapped])
                {
                       [sel addResidue: [alpos res2]];
                }
        }
        return sel;
}


-(NSArray*)alignmentPositions
{
        if (!computed)
        {
                NSLog(@"MTPairwiseSequenceAlignment needs to be computed first.");
                return nil;
        }
        return positions;
}

~~~

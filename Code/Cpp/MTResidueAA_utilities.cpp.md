
declared in [MTResidueAA](MTResidueAA.hpp.md)

~~~ { .cpp }

std::string MTResidueAA::translate3to1Code(std::string const & c3)
{
	if (c3.empty() || c3.size() < 3) { return "?"; }
	const char *s = c3.c_str();
	switch (s[0]) {
	case 'A':
		if (s[1]=='L' && s[2]=='A') { return "A"; }
		if (s[1]=='S' && s[2]=='N') { return "N"; }
		if (s[1]=='S' && s[2]=='P') { return "D"; }
		if (s[1]=='R' && s[2]=='G') { return "R"; }
		break;
	case 'C':
		if (s[1]=='Y' && s[2]=='S') { return "C"; }
		break;
	case 'G':
		if (s[1]=='L' && s[2]=='Y') { return "G"; }
		if (s[1]=='L' && s[2]=='N') { return "Q"; }
		if (s[1]=='L' && s[2]=='U') { return "E"; }
		break;
	case 'H':
		if (s[1]=='I' && s[2]=='S') { return "H"; }
		break;
	case 'I':
		if (s[1]=='L' && s[2]=='E') { return "I"; }
		break;
	case 'L':
		if (s[1]=='E' && s[2]=='U') { return "L"; }
		if (s[1]=='Y' && s[2]=='S') { return "K"; }
		break;
	case 'M':
		if (s[1]=='E' && s[2]=='T') { return "M"; }
		break;
	case 'P':
		if (s[1]=='H' && s[2]=='E') { return "F"; }
		if (s[1]=='R' && s[2]=='O') { return "P"; }
		break;
	case 'S':
		if (s[1]=='E' && s[2]=='R') { return "S"; }
		break;
	case 'T':
		if (s[1]=='H' && s[2]=='R') { return "T"; }
		if (s[1]=='Y' && s[2]=='R') { return "Y"; }
		if (s[1]=='R' && s[2]=='P') { return "W"; }
		break;
	case 'V':
		if (s[1]=='A' && s[2]=='L') { return "V"; }
		break;
	}
	return "?";
}

std::string MTResidueAA::translate1to3Code(std::string const & c1)
{
	if (c1.empty() || c1.size() < 1) { return "UNK"; }
	const char *s = c1.c_str();
	switch(s[0]) {
	case 'A' : return "ALA"; break;
	case 'C' : return "CYS"; break;
	case 'D' : return "ASP"; break;
	case 'E' : return "GLU"; break;
	case 'F' : return "PHE"; break;
	case 'G' : return "GLY"; break;
	case 'H' : return "HIS"; break;
	case 'I' : return "ILE"; break;
	case 'K' : return "LYS"; break;
	case 'L' : return "LEU"; break;
	case 'M' : return "MET"; break;
	case 'N' : return "ASN"; break;
	case 'P' : return "PRO"; break;
	case 'Q' : return "GLN"; break;
	case 'R' : return "ARG"; break;
	case 'S' : return "SER"; break;
	case 'T' : return "THR"; break;
	case 'V' : return "VAL"; break;
	case 'W' : return "TRP"; break;
	case 'Y' : return "TYR"; break;
	}
	return "UNK";
}


~~~


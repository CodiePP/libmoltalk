
## scoreBetween

~~~ { .cpp }
float MTSubstitutionMatrixIdentity::scoreBetween(char ch1, char ch2) const
{
	if (ch1 == ch2) return 2.0f; // match
	return -1.0f; // penalty
}

~~~


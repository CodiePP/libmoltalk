
declared in [MTCoordinates](MTCoordinates.hpp.md)

~~~ { .cpp }

bool MTCoordinates::operator==(MTCoordinates const & c) const
{
	if (atDim(0) != c.atDim(0)) { return false; }
	if (atDim(1) != c.atDim(1)) { return false; }
	if (atDim(2) != c.atDim(2)) { return false; }
	return true;
}
~~~


original objc code:

~~~ { .ObjectiveC }

~~~


declared in [MTCoordinates](MTCoordinates.hpp.md)

~~~ { .cpp }

MTCoordinates::MTCoordinates()
	: MTVector(4)
{
	atDim(0,0);
	atDim(1,0);
	atDim(2,0);
	atDim(3,1.0);
}
   
MTCoordinates::MTCoordinates(double x, double y, double z)
	: MTVector(4)
{
	atDim(0,x);
	atDim(1,y);
	atDim(2,z);
	atDim(3,1.0);
}

MTCoordinates::MTCoordinates(MTCoordinates const & p_coords)
	: MTVector(4)
{
	atDim(0,p_coords.x());
	atDim(1,p_coords.y());
	atDim(2,p_coords.z());
	atDim(3,1.0);
}

MTCoordinates::MTCoordinates(MTVector const & p_vect)
	: MTVector(p_vect)
{}

~~~


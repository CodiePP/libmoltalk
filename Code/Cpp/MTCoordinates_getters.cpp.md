
declared in [MTCoordinates](MTCoordinates.hpp.md)

~~~ { .cpp }

double MTCoordinates::x() const
{ return atDim(0); }

double MTCoordinates::y() const
{ return atDim(1); }

double MTCoordinates::z() const
{ return atDim(2); }

~~~

## coordinates to hash value

we compute the hashvalue of three-dimensional coordinates
by mapping it to a fixed numerical range or grid. The width
is defined by the selection of bits to encode the hashvalue.

> input:-320          0       +320
>          0         320       640
>          |----------|---------|
> output:  0          32        64 (6 bits) // (HASH_GRID_SIZE=10.0)
> output:  0          64       128 (7 bits) // (HASH_GRID_SIZE=5.0)
> output:  0         128       256 (8 bits) // (HASH_GRID_SIZE=2.5)
> output:  0         256       512 (9 bits) // (HASH_GRID_SIZE=1.25)
> output:  0         512      1024 (10 bits) // (HASH_GRID_SIZE=0.625)
>
> input:-499          0       +499
>          0         499       998
>          |----------|---------|
> output:  0          32        64 (6 bits) // (HASH_GRID_SIZE=15.6)
> output:  0          64       128 (7 bits) // (HASH_GRID_SIZE=7.8)
> output:  0         128       256 (8 bits) // (HASH_GRID_SIZE=3.9)
> output:  0         256       512 (9 bits) // (HASH_GRID_SIZE=1.95)
> output:  0         512      1024 (10 bits) // (HASH_GRID_SIZE=0.975)

~~~ { .cpp }

#define MAX_RANGE (499.0+499.0)
template<int W>
long MTCoordinates::hash() const
{
    double _x = x();
    double _y = y();
    double _z = z();

    long hashv=0L;
    long mask = (1UL << W) - 1;  // i.e. 0x01000 -1 = 0x00fff
    double factor = double(1UL << W);
    int hashingbits = W;
    _x = (_x+(MAX_RANGE/2.0)) / MAX_RANGE * factor;
    if (_x<0.0) { _x=0.0; printf("clipping -x\n"); }
    if (_x>factor) { _x=factor; printf("clipping +x\n"); }
    _y = (_y+(MAX_RANGE/2.0)) / MAX_RANGE * factor;
    if (_y<0.0) { _y=0.0; printf("clipping -y\n"); }
    if (_y>factor) { _y=factor; printf("clipping +y\n"); }
    _z = (_z+(MAX_RANGE/2.0)) / MAX_RANGE * factor;
    if (_z<0.0) { _z=0.0; printf("clipping -z\n"); }
    if (_z>factor) { _z=factor; printf("clipping +z\n"); }
    hashv = (long)(_x+0.5) & mask;
    hashv |= ((long)(_y+0.5) & mask)<<hashingbits;
    hashv |= (((long)(_z+0.5) & mask)<<hashingbits)<<hashingbits;
    // hashv is now a 3 times HASHING_BITS number encoding coordinates
    //printf("mask:%lx factor:%1.1f hashv:%lx x:%1.1f y:%1.1f z:%1.1f -> x:%1.1f y:%1.1f z:%1.1f\\n",mask,factor,hashv,x(),y(),z(),_x,_y,_z);
    return hashv;
}

long MTCoordinates::hash6() const { return hash<6>(); }

long MTCoordinates::hash7() const { return hash<7>(); }

long MTCoordinates::hash8() const { return hash<8>(); }

long MTCoordinates::hash9() const { return hash<9>(); }

long MTCoordinates::hash10() const { return hash<10>(); }

~~~


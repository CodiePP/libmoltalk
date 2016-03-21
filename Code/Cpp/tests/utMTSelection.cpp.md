~~~ { .cpp }

#ifndef BOOST_ALL_DYN_LINK
#define BOOST_ALL_DYN_LINK
#endif

#include "boost/test/unit_test.hpp"


#include "MTSelection.hpp"

#include <iostream>
~~~

# Test suite: utMTSelection

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE( utMTSelection )
~~~

## Test case: 
~~~ { .cpp }
BOOST_AUTO_TEST_CASE( test101 )
{
	mt::MTSelection _sel;
}
~~~

~~~ { .cpp }
BOOST_AUTO_TEST_SUITE_END()
~~~

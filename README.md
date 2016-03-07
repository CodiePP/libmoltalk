# libmoltalk

structural bioinformatics algorithms

## Features

* tbd


## License

This library is protected by the viral GNU GPL v3.
You may read the consequences in this [FAQ](https://www.gnu.org/licenses/gpl-faq.html).
Other licenses are available on request. Just get in contact with us.

## Installation

At the root besides the "libmoltalk" files you should have already cloned "gitalk" which provides basic scripts to generate source code from markup files.

>dev$ clone https://github.com/CodiePP/gitalk.git

>dev$ clone https://github.com/CodiePP/libmoltalk.git

enter libmoltalk and generate source code

>dev$ cd libmoltalk

>dev$ cd src/Cpp

>dev$ ./mk_libmoltalk.sh

enter libmoltalk's root and create Makefiles

>dev$ cd ../../

>dev$ cmake -D CMAKE_BUILD_TYPE=Debug

then, compile and link
>dev$ make

the unit tests are found in 
>dev$ cd src/Cpp/tests

>dev$ ./UT_libmoltalk

## Dependencies

[boost](http://www.boost.org)

[gitalk](https://github.com/CodiePP/gitalk)


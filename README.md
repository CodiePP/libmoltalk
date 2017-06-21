# libmoltalk

structural bioinformatics algorithms

## visit our [pages](https://codiepp.github.io/libmoltalk/)

## CI
-- tbd --

## Source code

* Browse source code
[libmoltalk.md](Code/Cpp/libmoltalk.md)

* Browse test cases
[utlibmoltalk.md](Code/Cpp/tests/utlibmoltalk.md)

* Issues
[Kanban view](https://huboard.com/CodiePP/libmoltalk)


## Features

* tbd
* tbd
* tbd


## License

This library is protected by the viral GNU GPL v3.
You may read the consequences in this [FAQ](https://www.gnu.org/licenses/gpl-faq.html).
Other licenses are available on request. Just get in contact with us.

## Installation

At the root besides the "libmoltalk" files you should have already cloned "gitalk" which provides basic scripts to generate source code from markup files.

```
clone https://github.com/CodiePP/gitalk.git

clone https://github.com/CodiePP/libmoltalk.git
```

enter libmoltalk and generate source code

```
cd libmoltalk

cd src/Cpp

./mk_libmoltalk.sh
```

enter libmoltalk's root and create Makefiles

```
mkdir BUILD

cd BUILD

cmake -D CMAKE_BUILD_TYPE=Debug ..
```

then, compile and link

```
make -j 4
```

the unit tests are found in 

```
cd src/Cpp/tests

./UT_libmoltalk
```

## Dependencies

[boost](http://www.boost.org)

[gitalk](https://github.com/CodiePP/gitalk)


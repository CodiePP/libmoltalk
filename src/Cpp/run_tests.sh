#!/bin/bash

./tests/UT_libmoltalk --list_content > ut.list 2>&1

./tests/UT_libmoltalk --log_level=error --report_level=short



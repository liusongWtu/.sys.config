#!/bin/bash
# good experience with python.


function py(){
	pyenv global $1
}

function py2(){
	py 2.7.10
}

function py3(){
	py 3.6.3
}
#!/bin/bash

{
    bsub -app irun \
	 -Ip xrun \
	 -licqueue \
	 -f build.f \
	 -f files.f

} 2>&1 | tee $(basename $0).log

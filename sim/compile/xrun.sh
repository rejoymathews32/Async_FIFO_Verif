#!/bin/bash

{
    # module innovus 18.12.000

    bsub -app irun \
	 -Ip xrun \
	 -f build.f \
	 -f files.f

} 2>&1 | tee $(basename $0).log

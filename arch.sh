#!/bin/bash

date="$(date +'%Y%m%d%H%M%S')"
tar zcvf /dataout/data-$date.tar.gz /data

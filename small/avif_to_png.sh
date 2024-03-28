#!/bin/bash
for image in *.avif ;  do convert "$image" "${image%.*}.png" ; done

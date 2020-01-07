#!/bin/bash
echo "building..."
hugo
cd public
echo "blog.yourssu.com" >> CNAME
echo "DONE"

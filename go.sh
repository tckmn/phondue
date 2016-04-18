#!/bin/bash
src/builder.rb > src/builder.ui
src/digraphs.rb > src/digraphs.txt
make
bin/phondue

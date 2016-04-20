#!/bin/bash

# desktop
tools/builder.rb gtk > src/builder.ui
tools/digraphs.rb > src/digraphs.txt
make

# web
tools/builder.rb html > web/builder.html
tools/digraphs.rb > web/digraphs.txt

#!/bin/bash

# desktop
tools/digraphs.rb > src/digraphs.txt
tools/builder.rb gtk > src/builder.ui
make

# web
tools/digraphs.rb > web/digraphs.txt
tools/builder.rb html web/digraphs.txt > web/builder.html
tools/copyusage.rb README.md web/index.html | sponge web/index.html

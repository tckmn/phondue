#!/usr/bin/env ruby

files = Array.new(2) { ARGV.shift }
if !files.all? || !ARGV.empty?
    abort "usage: #{$0} [readme] [index.html]"
end

readme, index = files.map{|filename| open(filename).readlines.map &:chomp }

usage_markdown = readme.slice_before(/^#/).to_a.assoc('## Usage') * "\n"
usage_html = IO.popen('md', mode='r+') do |io|
    io.write usage_markdown
    io.close_write
    io.read
end

index = index.slice_when{|a, b|
    a == '<!--STARTUSAGE-->' || b == '<!--ENDUSAGE-->'
}.to_a
index[1] = usage_html
index = index.flatten * "\n"
puts index

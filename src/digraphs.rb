#!/usr/bin/env ruby

data = '
    j-ɟ GGɢ ??ʔ
    m,ɱ n,ŋ ŋ,ɲ NNɴ
    BBʙ RRʀ
    PHɸ BHβ THθ DHð SHʃ ZHʒ c,ç j,ʝ x,ɣ ɣ,χ XXχ ʀ/ʁ h-ħ ʔ/ʕ ?/ʕ h,ɦ
    l-ɬ LZɮ
'
data = data.scan(/\S/).each_slice(3).flat_map{|digraph|
    if digraph.join =~ /^[!-~]{2}/
        [digraph]
    else
        [digraph, digraph.reverse]
    end
}

puts data.map{|digraph|
    digraph.map!{|ch|
        ch.encode('utf-32').bytes[-4..-1].map{|x| x.to_s(16).rjust(2, ?0)} * ''
    }
    "#{digraph[0]}#{digraph[1]} #{digraph[2]}"
}.sort

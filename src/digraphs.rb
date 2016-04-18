#!/usr/bin/env ruby

data = '
    {{ symbols that can be found in the clickable table as well }}
    j-ɟ GGɢ ??ʔ
    m,ɱ n,ŋ ŋ,ɲ NNɴ
    BBʙ RRʀ
    v,ⱱ rOɾ r0ɾ
    PHɸ BHβ THθ DHð SHʃ ZHʒ c,ç j,ʝ x,ɣ ɣ,χ XXχ ʀ/ʁ h-ħ ʔ/ʕ ?/ʕ h,ɦ
    l-ɬ LZɮ
    vOʋ v0ʋ r/ɹ w,ɰ w|ɰ
    y/ʎ LLʟ

    i-ɨ u-ʉ m/ɯ
    IIɪ YYʏ UUʊ
    o/ø e-ɘ o-ɵ OXɤ XOɤ
    e/ə
    EEɛ OEœ ɛ/ɜ EBɞ ɜ(ɞ OOɞ /\\ʌ c/ɔ
    AEæ a/ɐ
    CEɶ o|ɑ a|ɑ AAɑ |oɒ |aɒ ɑ/ɒ

    {{ retroflexes }}
    t)ʈ d)ɖ n)ɳ r)ɽ ɾ)ɽ s)ʂ z)ʐ ɹ)ɻ l)ɭ

    {{ non-pulmonics }}
    o.ʘ o*ʘ |*ǀ !*ǃ |=ǂ =*ǁ
    b(ɓ d(ɗ j(ʄ ɟ(ʄ g(ɠ ɢ(ʛ
    \')ʼ

    {{ misc. symbols }}
    w/ʍ h/ɥ HHʜ ʕ-ʢ ?-ʡ ʔ-ʡ SJɕ ZJʑ RLɺ LRɺ ɾlɺ lɾɺ ʃxɧ xʃɧ ((͡ ))͜

    {{ diacritics }}
    _|̩^|̍ _^̯
    ^>̚
    _o̥^o̊ _v̬^v̌ _:̤ _~̰
    _[̪ _]̺ _{̼ []̻ _#̻ _+̟ __̠ ^:̈ ^x̽ -\'˔ _˔̝ -,˕ _˕̞
    _)̹ _(̜ ~~̴ <|⊣ _⊣̘ >|⊢ _⊢̙ ^~̃ >r˞

    {{ superscripts (TODO: add more nasal and lateral releases) }}
    ^hʰ ^nⁿ ^lˡ ^wʷ ^jʲ ^ɥᶣ ^ʋᶹ ^ɣˠ ^ʕˤ

    {{ suprasegmentals }}
    \'\'ˈ ,,ˌ ::ː ː-ˑ ^ŭ_u̮ ͜)‿
    ||‖ /^↗ />↗ \\v↘ \\>↘
    ^"̋ ^\'́ ^-̄ _\'̀ _"̏ 1|˥ 2|˦ 3|˧ 4|˨ 5|˩ +|ꜛ ^v̌ ^^̂ -|ꜜ

    {{ unofficial IPA symbols }}
    k/ʞ !/¡ ɖ(ᶑ ɗ)ᶑ
'

data = data.gsub(/\{\{[^}]*\}\}/, '').scan(/\S/).each_slice(3).flat_map{|digraph|
    digraph.join =~ /^[!-~]{2}/ ? [digraph] : [digraph, digraph.reverse]
}.flat_map{|digraph|
    [digraph, digraph.join.sub(/[a-z]/){|x|x.upcase}.chars].uniq
}.flat_map{|digraph|
    digraph.join =~ /[^_><-]/ ? [digraph, [digraph[1], digraph[0], digraph[2]]] : [digraph]
}

puts data.map{|digraph|
    digraph.map!{|ch|
        ch.encode('utf-32').bytes[-4..-1].map{|x| x.to_s(16).rjust(2, ?0)} * ''
    }
    "#{digraph[0]}#{digraph[1]} #{digraph[2]}"
}.sort

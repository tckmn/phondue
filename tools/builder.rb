#!/usr/bin/env ruby

data = '1|2Bilabial|2Labiodental|2Dental|2Alveolar|2Postalveolar|2Palatal|2Velar|2Uvular|2Pharyngeal|2Glottal
1Plosive            |p|b|_|_|_|_|t|d|_|_|c|ɟ|k|g|q|ɢ|_|#|ʔ|#
1Nasal              |_|m|_|ɱ|_|_|_|n|_|_|_|ɲ|_|ŋ|_|ɴ|#|#|#|#
1Trill              |_|ʙ|_|_|_|_|_|r|_|_|_|_|#|#|_|ʀ|_|_|#|#
1Tap/Flap           |_|_|_|ⱱ|_|_|_|ɾ|_|_|_|_|#|#|_|_|_|_|#|#
1Fricative          |ɸ|β|f|v|θ|ð|s|z|ʃ|ʒ|ç|ʝ|x|ɣ|χ|ʁ|ħ|ʕ|h|ɦ
1Lateral fricative  |#|#|#|#|_|_|ɬ|ɮ|_|_|_|_|_|_|_|_|#|#|#|#
1Approximant        |_|_|_|ʋ|_|_|_|ɹ|_|_|_|j|_|ɰ|_|_|_|_|#|#
1Lateral approximant|#|#|#|#|_|_|_|l|_|_|_|ʎ|_|ʟ|_|_|#|#|#|#
1|2Front|2Central|2Back|1|2Non-pulmonic|1|2Other|1|7Diacritics
1Close     |i|y|ɨ|ʉ|ɯ|u|_|ʘ|ǀ          |_|ʍ|w   |_|◌̥|◌̬|◌̤|◌̰|◌̩|◌̯
1Near-close|ɪ|ʏ|_|_|_|ʊ|_|ǃ|ǂ          |_|ɥ|ʜ   |_|◌̪|◌̼|◌̺|◌̻|◌ʰ|◌̚
1Close-mid |e|ø|ɘ|ɵ|ɤ|o|_|ǁ|¡          |_|ʢ|ʡ   |_|◌̟|◌̠|◌̈|◌̽|◌̝|◌̞
1Mid       |_|_|ə|_|_|_|_|ʞ|ʼ          |_|ɕ|ʑ   |_|◌ʷ|◌ʲ|◌ᶣ|◌ᶹ|◌ˠ|◌ˤ|◌̴
1Open-mid  |ɛ|œ|ɜ|ɞ|ʌ|ɔ|_|ɓ|ɗ          |_|ɺ|ɧ   |_|◌̹|◌̜|◌̘|◌̙|◌̃|◌˞
1Near-open |æ|_|ɐ|_|_|_|_|ᶑ|ʄ          |_|_|_   |_|
1Open      |a|ɶ|_|_|ɑ|ɒ|_|ɠ|ʛ          |_|2Suprasegmental|ˈ|ˌ|ː|ˑ|◌̆|BAR|‖|‿
'

mode = ARGV.shift
if (mode != 'gtk' && mode != 'html') || (!ARGV.empty?)
    abort "usage: #{$0} gtk\n       #{$0} html"
end
gtk = mode == 'gtk'
html = mode == 'html'

if gtk then puts "
<interface>
    <object id='window' class='GtkWindow'>
        <property name='visible'>True</property>
        <property name='title'>Phondue</property>
        <property name='border-width'>10</property>

        <child>
            <object id='grid' class='GtkGrid'>
                <property name='visible'>True</property>"
elsif html then puts "
<table>
    <tbody>"
end

data.split("\n").each_with_index do |line, i|
    xpos = 0
    if html then puts "
        <tr>"
    end
    line.split(?|).each_with_index do |cell, j|
        cell.strip!
        grey = cell == ?#
        empty = cell == ?_
        cell = '' if grey || empty

        label_width = if cell =~ /^\d/; cell.match(/\d/)[0].to_i; end
        cell.sub! /^\d/, ''

        if cell.bytes[0..2] == [226, 151, 140]
            cell = cell.bytes[3..-1].pack('c*')
        end

        cell = ?| if cell == 'BAR'

        is_button = !(grey || empty || label_width)

        if gtk then puts "
                <child>
                    <object id='cell_#{i}_#{j}' class='#{is_button ? 'GtkButton' : 'GtkLabel'}'>
                        <property name='visible'>True</property>
                        #{is_button ? "<property name='relief'>GTK_RELIEF_NONE</property>" : ''}
                        <property name='label'>#{cell}</property>
                        #{grey ? "<style><class name='grey'/></style>" : ''}
                    </object>
                    <packing>
                        <property name='top-attach'>#{i}</property>
                        <property name='left-attach'>#{xpos}</property>
                        #{label_width ? "<property name='width'>#{label_width}</property>" : ''}
                    </packing>
                </child>"
        elsif html then puts "
            <td id='cell_#{i}_#{j}' class='#{is_button ? 'td-btn' : 'td-lbl'}#{' grey' if grey}'#{" colspan='#{label_width}'" if label_width}>
                #{'<button>' if is_button}
                    #{cell}
                #{'</button>' if is_button}
            </td>"
        end

        xpos += label_width || 1
    end
    if html then puts "
        </tr>"
    end
end

if gtk then puts "
                <child>
                    <object id='input' class='GtkEntry'>
                        <property name='visible'>True</property>
                    </object>
                    <packing>
                        <property name='top-attach'>#{data.count "\n"}</property>
                        <property name='left-attach'>0</property>
                        <property name='width'>21</property>
                    </packing>
                </child>
            </object>
            <packing/>
        </child>
    </object>
</interface>"
elsif html then puts "
</table>"
end

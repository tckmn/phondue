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
1|2Front|2Central|2Back
1Close|i|y|ɨ|ʉ|ɯ|u
1Near-close|ɪ|ʏ|_|_|_|ʊ
1Close-mid|e|ø|ɘ|ɵ|ɤ|o
1Mid|_|_|ə
1Open-mid|ɛ|œ|ɜ|ɞ|ʌ|ɔ
1Near-open|æ|_|ɐ
1Open|a|ɶ|_|_|ɑ|ɒ
'

puts "
<interface>
    <object id='window' class='GtkWindow'>
        <property name='visible'>True</property>
        <property name='title'>Phondue</property>
        <property name='border-width'>10</property>

        <child>
            <object id='grid' class='GtkGrid'>
                <property name='visible'>True</property>"

data.split("\n").each_with_index do |line, i|
    xpos = 0
    line.split(?|).each_with_index do |cell, j|
        grey = cell == ?#
        empty = cell == ?_
        cell = '' if grey || empty

        label_width = if cell =~ /^\d/; cell.match(/\d/)[0].to_i; end
        cell.sub! /^\d/, ''

        is_button = !(grey || empty || label_width)

        puts "
                <child>
                    <object id='cell_#{i}_#{j}' class='#{is_button ? 'GtkButton' : 'GtkLabel'}'>
                        <property name='visible'>True</property>
                        #{is_button ? "<property name='relief'>GTK_RELIEF_NONE</property>" : ''}
                        <property name='label'>#{cell.strip}</property>
                        #{grey ? "<style><class name='grey'/></style>" : ''}
                    </object>
                    <packing>
                        <property name='top-attach'>#{i}</property>
                        <property name='left-attach'>#{xpos}</property>
                        #{label_width ? "<property name='width'>#{label_width}</property>" : ''}
                    </packing>
                </child>"

        xpos += label_width || 1
    end
end

puts "
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

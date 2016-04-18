#!/usr/bin/env ruby

data = '|Bilabial|Labiodental|Dental|Alveolar|Postalveolar|Palatal|Velar|Uvular|Pharyngeal|Glottal
Plosive            |p|b|_|_|_|_|t|d|_|_|c|ɟ|k|g|q|ɢ|_|#|ʔ|#
Nasal              |_|m|_|ɱ|_|_|_|n|_|_|_|ɲ|_|ŋ|_|ɴ|#|#|#|#
Trill              |_|ʙ|_|_|_|_|_|r|_|_|_|_|#|#|_|ʀ|_|_|#|#
Tap/Flap           |_|_|_|ⱱ|_|_|_|ɾ|_|_|_|_|#|#|_|_|_|_|#|#
Fricative          |ɸ|β|f|v|θ|ð|s|z|ʃ|ʒ|ç|ʝ|x|ɣ|χ|ʁ|ħ|ʕ|h|ɦ
Lateral fricative  |#|#|#|#|_|_|ɬ|ɮ|_|_|_|_|_|_|_|_|#|#|#|#
Approximant        |_|_|_|ʋ|_|_|_|ɹ|_|_|_|j|_|ɰ|_|_|_|_|#|#
Lateral approximant|#|#|#|#|_|_|_|l|_|_|_|ʎ|_|ʟ|_|_|#|#|#|#'

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
    line.split(?|).each_with_index do |cell, j|
        next if cell.strip.empty?
        grey = cell == ?#
        is_button = !grey && cell != ?_
        cell = '' unless is_button
        is_button &= i != 0 && j != 0
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
                        <property name='left-attach'>#{i == 0 ? j*2-1 : j}</property>
                        #{i == 0 ? "<property name='width'>2</property>" : ''}
                    </packing>
                </child>"
    end
end

puts "
                <child>
                    <object id='input' class='GtkEntry'>
                        <property name='visible'>True</property>
                    </object>
                    <packing>
                        <property name='top-attach'>9</property>
                        <property name='left-attach'>0</property>
                        <property name='width'>21</property>
                    </packing>
                </child>
            </object>
            <packing/>
        </child>
    </object>
</interface>"

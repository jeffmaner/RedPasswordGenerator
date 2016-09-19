Red [ Title: "Password Generation"
      Author: "Jeff Maner"
      Date: "2016-08-15"
]

select-words: func [
    "Randomly select words from word list."

    words-needed [ integer! ]
    word-list [ series! ]

    /local selected-words
] [
    selected-words: copy []
    loop words-needed [
        append selected-words random/only word-list ]
    selected-words
]

transform-words: func [
    "Transform words per transformation."

    words [ series! ]
    transformation

    /local ws
] [
    ws: copy []

    switch/default transformation [
        no-transformation [ ws: copy words ]
        alternating-word [
            alteration: 'lowercase
            foreach word words [
                either alteration = 'lowercase [
                    alteration: 'uppercase
                    append ws lowercase word
                ] [
                    alteration: 'lowercase
                    append ws uppercase word
                ] ] ]
        first-letter [
            foreach word words [
                lowercase word
                append ws uppercase/part word 1 ] ]
        tail-letter [
            foreach word words [
                uppercase word
                append ws lowercase/part word 1 ] ]
        lower-case [
            foreach word words [
                append ws lowercase word ] ]
        upper-case [
            foreach word words [
                append ws uppercase word ] ]
        random-word [
            foreach word words [
                append ws do reduce [ random/only [ lowercase uppercase ] word ] ] ]
    ] [ ]

    ws
]

pick-separator: func [
    "Pick separator based on separator-type."

    config "config-separator"
] [
    switch/default config/separator-type [
        'no-separator [ ]
        'random-character [ random/only config/chosen-from ]
        'specified-character [ config/character ]
    ] [ print "Unexpected separator-type." ]
]

get-pad-digits: func [ n [ integer! ] /local x ] [
    map-each 'x naturals/to n [ random 9 ]
]

get-padding-symbols: func [
    config
    words [ series! ] "transformed-words"

    /local symbols-before symbols-after padding-symbols
] [
    symbols-before:  copy []
    symbols-after:   copy []
    padding-symbols: copy []

    switch/default config/config-padding-symbols/padding-type [
        'no-padding [ ]
        'fixed-padding [
            symbol: either config/config-padding-symbols/padding-character = 'random-character [
                random/only config/config-padding-symbols/chosen-from ] [
                config/config-padding-symbols/character ]
            loop config/config-padding-symbols/symbols-before [ append symbols-before symbol ]
            loop config/config-padding-symbols/symbols-after [ append symbols-after symbol ] ]
        'adaptive-padding [
            character-count: 0
            foreach word words [
                character-count: character-count + length? word ]
            character-count: character-count
                + 1 ;; For separator.
                + config/config-padding-digits/digits-before
                + config/config-padding-digits/digits-after
            characters-required: to integer! config/config-padding-symbols/pad-to-length
            character: either config/config-padding-symbols/padding-character = 'random-character [
                random/only config/config-padding-symbols/chosen-from ] [
                config/config-padding-symbols/character ]
            loop characters-required - character-count [
                append padding-symbols character ] ]
    ] [ ]

    either empty? padding-symbols [
        reduce [ 'before symbols-before 'after symbols-after ] ] [
        padding-symbols ]
]

generate-password: func [
    words [ series! ]
    config [ block! ]

    /local selected-words transformed-words separator pad-digits-before
           pad-digits-after padding-symbols password
] [
    selected-words: select-words config/config-words/word-count words
    transformed-words: transform-words selected-words config/config-transformations/case-transformation
    separator: pick-separator config/config-separator
    pad-digits-before: get-pad-digits config/config-padding-digits/digits-before
    pad-digits-after: get-pad-digits config/config-padding-digits/digits-after
    padding-symbols: get-padding-symbols config transformed-words

    password: copy []

    unless empty? padding-symbols [
        unless error? try [ padding-symbols/before ] [
            unless empty? padding-symbols/before [
                append password padding-symbols/before ] ] ]
    unless empty? pad-digits-before [ append password pad-digits-before ]
    foreach w naturals/to length? transformed-words [
        unless none? separator [ append password separator ]
        append password transformed-words/(w) ]
    unless (none? separator) or (separator = " ") [ append password separator ]
    unless empty? pad-digits-after [ append password pad-digits-after ]
    unless empty? padding-symbols [
        either none? padding-symbols/after [
            append password padding-symbols ] [
            unless empty? padding-symbols/after [
                append password padding-symbols/after ] ] ]

    trim join "" password
]

;; vim:ft=red

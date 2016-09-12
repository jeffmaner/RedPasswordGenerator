Rebol [ Title: "Password Generator"
        Author: "Jeff Maner"
        Date: 2016-08-15
        Inspired-by: https://xkpasswd.net/s/
]

do load %ancillary.r
do load %config.r

words: read/lines config-words/dictionary
remove-each line words [ #"#" = first line ]

words-needed: do config-words/word-count 
minimum-word-length: do config-words/minimum-length
maximum-word-length: do config-words/maximum-length

filtered-words: remove-each word words [
    n: length? word
    (n < minimum-word-length) or
    (n > maximum-word-length) ]

selected-words: copy []
loop words-needed [
    append selected-words random/only filtered-words ]

transformed-words: switch do config-transformations/case-transformation [
    no-transformation [ transformed-words: selected-words ]
    alternating-word [
      alteration: 'lowercase
      map-each word selected-words [
          either alteration = 'lowercase [
              alteration: 'uppercase
              lowercase word
          ] [
              alteration: 'lowercase
              uppercase word
          ] ] ]
    first-letter [
        map-each word selected-words [
            lowercase word
            uppercase/part word 1 ] ]
    tail-letter [
        map-each word selected-words [
            uppercase word
            lowercase/part word 1 ] ]
    lower-case [
        map-each word selected-words [
            lowercase word ] ]
    upper-case [
        map-each word selected-words [
            uppercase word ] ]
    random-word [
        map-each word selected-words [
            random/only [ lowercase uppercase ] word ] ]
]

separators: switch config-separator/separator-type [
    separator-types/no-separator []
    separator-types/random-character [
        append [] random/seed/only separator-types/random-character/alphabet 
        ;; characters: copy []
        ;; append characters random/seed/only separator-types/random-character/alphabet
        ;; append
        ;;     append characters
        ;;         map-each w transformed-words [
        ;;             random/seed/only separator-types/random-character/alphabet ]
        ;;         random/seed/only separator-types/random-character/alphabet ]
    ]
    separator-types/specified-character [
        do config-separator/separator-type/character ]
]

pad-digits-before: copy []
loop do config-padding-digits/digits-before [
    append pad-digits-before random 9 ]

pad-digits-after: copy []
loop do config-padding-digits/digits-after [
    append pad-digits-after random 9 ]

symbols-before:  copy []
symbols-after:   copy []
padding-symbols: copy []
switch do config-padding-symbols/padding-type [
    no-padding []
    fixed-padding [
        symbol: random/only alphabet
        loop 2 [ append symbols-before symbol ]
        loop 2 [ append symbols-after symbol ]
        ;; alphabet: padding-characters/random-character/alphabet
        ;; loop do padding-types/fixed-padding/symbols-before [
        ;;     append symbols-before random/only alphabet ]
        ;; loop do padding-types/fixed-padding/symbols-after [
        ;;     append symbols-after random/only alphabet ]
    ]
    adaptive-padding [
        character-count: 0
        foreach word transformed-words [
            character-count: character-count + length? word ]
        character-count: character-count + length? separators
        character-count: character-count + length? pad-digits-before
        character-count: character-count + length? pad-digits-after
        characters-required: padding-types/adaptive-padding/pad-to-length
        loop characters-required - character-count [
            append padding-symbols padding-characters/specified-character/character ] ]
]

password: copy []
unless empty? symbols-before [ append password symbols-before ]
unless empty? pad-digits-before [ append password pad-digits-before ]
for w 1 length? transformed-words 1 [
    ;; unless empty? separators [ append password separators/(w + 1) ]
    unless empty? separators [ append password separators/(1) ]
    append password transformed-words/(w) ]
unless empty? separators [
    ;; append password separators/(1 + length? transformed-words) ]
    append password separators/(1) ]
unless empty? pad-digits-after [ append password pad-digits-after ]
unless empty? symbols-after [ append password symbols-after ]
unless empty? padding-symbols [ append password padding-symbols ]

join "" password

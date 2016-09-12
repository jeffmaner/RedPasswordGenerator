Rebol [ Title: "Password Generator"
        Author: "Jeff Maner"
        Date: 2016-08-15
        Inspired-by: https://xkpasswd.net/s/
]

do load %config.r

words: read/lines config-words/dictionary
remove-each line words [ #"#" = first line ]

words-needed: do config-words/word-count 
minimum-word-length: do config-words/minimum-length
maximum-word-length: do config-words/maximum-length

selected-words: copy []
until [
    word: random/only words
    n: length? word

    if (n >= minimum-word-length) and (n <= maximum-word-length) [
        append selected-words word ]

    words-needed = length? selected-words
]

transformed-words: copy []
switch do config-transformations/case-transformation [
    no-transformation [ transformed-words: selected-words ]
    alternating-word [
      alteration: 'lowercase
      foreach word selected-words [
          either alteration = 'lowercase [
              append transformed-words lowercase word
              alteration: 'uppercase
          ] [
              append transformed-words uppercase word
              alteration: 'lowercase
          ] ] ]
    first-letter [
        foreach word selected-words [
            lowercase word
            append transformed-words uppercase/part word 1 ] ]
    tail-letter [
        foreach word selected-words [
            uppercase word
            append transformed-words lowercase/part word 1 ] ]
    lower-case [
        foreach word selected-words [
            append transformed-words lowercase word ] ]
    upper-case [
        foreach word selected-words [
            append transformed-words uppercase word ] ]
    random-word [
        foreach word selected-words [
            append transformed-words random/only [ lowercase uppercase ] word ] ]
]

separators: switch config-separator/separator-type [
    separator-types/no-separator []
    separator-types/random-character [
        append
            map-each w transformed-words [
                random/only separator-types/random-character/alphabet ]
            random/only separator-types/random-character/alphabet ]
    separator-types/specified-character [
        do config-separator/separator-type/character ]
]

pad-digits-before: copy []
for d 1 do config-padding-digits/digits-before 1 [
    append pad-digits-before random 9 ]

pad-digits-after: copy []
for d 1 do config-padding-digits/digits-after 1 [
    append pad-digits-after random 9]

symbols-before: copy []
symbols-after:  copy []
padding-symbols: copy []
switch do config-padding-symbols/padding-type [
    no-padding []
    fixed-padding [
        for d 1 do padding-types/fixed-padding/symbols-before 1 [
            append symbols-before random/only padding-characters/random-character/alphabet ]
        for d 1 do padding-types/fixed-padding/symbols-after 1 [
            append symbols-after random/only padding-characters/random-character/alphabet ] ]
    adaptive-padding [
        character-count: 0
        foreach word transformed-words [
            character-count: character-count + length? word ]
        character-count: character-count + length? separators
        character-count: character-count + length? pad-digits-before
        character-count: character-count + length? pad-digits-after
        characters-required: padding-types/adaptive-padding/pad-to-length
        for d character-count characters-required 1 [
            append padding-symbols padding-characters/specified-character/character ] ]
]

password: copy []
for s 1 length? symbols-before 1 [
    append password symbols-before/(s) ]
for d 1 length? pad-digits-before 1 [
    append password pad-digits-before/(d) ]
for w 1 length? transformed-words 1 [
    append password separators/(w)
    append password transformed-words/(w) ]
append password separators/(1 + length? transformed-words)
for d 1 length? pad-digits-after 1 [
    append password pad-digits-after/(d) ]
for s 1 length? symbols-after 1 [
    append password symbols-after/(s) ]

join "" password

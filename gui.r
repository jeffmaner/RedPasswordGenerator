Red [ Title: "Password Generation GUI"
      Author: "Jeff Maner"
      Date: "2016-08-24"
      Needs: 'view
]

;; TODO: Refactor everything to enforce local scope and minimize globals.
;; TODO: Refactor to shorter names.
;; TODO: Test all preset loads and generated passwords.
;; TODO: Test all preset loads and generated passwords with fresh instances.
;; TODO: Refactor group-boxes and view.
;; TODO: Implement save/load of custom configuration.
;; TODO: Implement dictionary selection.

do load %ancillary.r

filter-words: func [
    words [ series! ]
    config [ block! ]

    /local words-needed minimum-word-length maximum-word-length filtered-words word n
] [
    words-needed: do config/config-words/word-count
    minimum-word-length: do config/config-words/minimum-length
    maximum-word-length: do config/config-words/maximum-length

    filtered-words: copy words
    remove-each word filtered-words [
        n: length? word
        (n < minimum-word-length) or
        (n > maximum-word-length) ]

    filtered-words
]

generate-passwords: func [
    config [ block! ]
    passwords [ integer! ]

    /local words line generated-passwords password
] [
    words: read/lines config-words/dictionary
    remove-each line words [ #"#" = first line ]

    filtered-words: filter-words words config

    do load %password.r
    generated-passwords: copy []
    foreach n naturals/to passwords [
        append generated-passwords generate-password filtered-words config ]

    do load %entropy.r

    compose/deep [
        passwords [(reduce generated-passwords)]
        entropy [(reduce [
            (to integer! blind-entropy config)
             to integer! seen-entropy filtered-words config ])] ]
]

get-descriptions: func [
    types [ block! ]

    /local descriptions
] [
    descriptions: copy []

    foreach t types [
        append descriptions (t)/description ]

    descriptions
]

random-character: 2
specified-character: 3
fixed-padding: 2
adaptive-padding: 3

word-counts: [ 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" ]
word-lengths: [ 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" ]
password-counts: [ 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" ]

transformations:
[
    no-transformation "-none-"
    alternating-word "alternating WORD case"
    first-letter "Capitalize First Letter"
    tail-letter "cAPITALIZE eVERY lETTER eXCEPT tHE fIRST"
    lower-case "lower case"
    upper-case "UPPER CASE"
    random-word "EVERY word randomly CAPITALIZED or NOT"
]

separator-types:
[
    no-separator [ description: "-none-" ]
    random-character [
        description "Random Character"
        alphabet [
            #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"-" #"_" #"+" #"=" #":" #"|"
            #"~" #"?" #"/" #"." #";" ] ]
    specified-character [
        description "Specified Character"
        character #"-" ]
]

separator-descriptions: get-descriptions separator-types

padding-digits: [ 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" ]

padding-types:
[
    no-padding [ description "-none-" ]
    fixed-padding [
        description "Fixed"
        symbols-before padding-digits/3
        symbols-after  padding-digits/3 ]
    adaptive-padding [
        description "Adaptive"
        pad-to-length 12 ]
]

padding-descriptions: get-descriptions padding-types

padding-characters:
[
    use-separator-character [ description "Use Separator Character" ]
    random-character [
        description "Random Character"
        alphabet [
            #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"-" #"_" #"+" #"=" #":" #"|"
            #"~" #"?" #"/" #"." #";" ] ]
    specified-character [
        description "Specified Character"
        character #"*" ]
]

padding-characters-descriptions: get-descriptions padding-characters

apply-preset: func [
    preset
] [
    switch/default preset [
        'apple-id   [ do load %config-appleid.r   ]
        'default    [ do load %config-default.r   ]
        'ntlm       [ do load %config-ntlm.r      ]
        'security-q [ do load %config-securityq.r ]
        'web-16     [ do load %config-web16.r     ]
        'web-32     [ do load %config-web32.r     ]
        'wifi       [ do load %config-wifi.r      ]
        'xkcd       [ do load %config-xkcd.r      ]
    ] [ view/flags [ below text "Invalid Config." button "OK" [ unview ] ] [ 'modal ] ]

    ;user-specified-dictionary:

    user-specified-word-count/selected:
        (index? find word-counts config-words/word-count) + 1 / 2
    user-specified-min-len/selected:
        (index? find word-lengths config-words/minimum-length) + 1 / 2
    user-specified-max-len/selected:
        (index? find word-lengths config-words/maximum-length) + 1 / 2

    user-specified-case-trans/selected:
        (index? find transformations config-transformations/case-transformation) + 1 / 2

    user-specified-separator-type/selected:
        (index? find separator-types config-separator/separator-type) + 1 / 2
    if user-specified-separator-type/selected = random-character [
        user-specified-random-separator-char/text: config-separator/chosen-from ]
    if user-specified-separator-type/selected = specified-character [
        user-specified-specified-separator-char/text:
            form reduce [ config-separator/character ] ]

    user-specified-padding-digits-before/selected:
        (index? find padding-digits config-padding-digits/digits-before) + 1 / 2
    user-specified-padding-digits-after/selected:
        (index? find padding-digits config-padding-digits/digits-after) + 1 / 2

    user-specified-padding-type/selected:
        (index? find padding-types config-padding-symbols/padding-type) + 1 / 2
    if user-specified-padding-type/selected = fixed-padding [
        user-specified-fixed-padding-before/selected:
            (index? find padding-digits config-padding-symbols/symbols-before) + 1 / 2
        user-specified-fixed-padding-after/selected:
            (index? find padding-digits config-padding-symbols/symbols-after) + 1 / 2
        user-specified-fixed-padding-character/selected:
            (index? find padding-characters config-padding-symbols/padding-character) + 1 / 2
        user-specified-fixed-padding-alphabet/text:
            form reduce [ config-padding-symbols/chosen-from ]
        user-specified-fixed-padding-specified-character/text:
            form reduce [ config-padding-symbols/character ] ]
    if user-specified-padding-type/selected = adaptive-padding [
        user-specified-adaptive-padding-length/text:
            config-padding-symbols/pad-to-length
        user-specified-adaptive-padding-character/selected:
            (index? find padding-characters config-padding-symbols/padding-character) + 1 / 2
        user-specified-adaptive-padding-alphabet/text:
            form reduce [ config-padding-symbols/chosen-from ]
        user-specified-adaptive-padding-specified-character/text:
            form reduce [ config-padding-symbols/character ] ]
]

collect-config-settings: func [
] [
    probe compose/deep [
        config-words [
            word-count (word-counts/(user-specified-word-count/selected * 2 - 1))
            minimum-length (word-lengths/(user-specified-min-len/selected * 2 - 1))
            maximum-length (word-lengths/(user-specified-max-len/selected * 2 - 1)) ]
        config-transformations [
            case-transformation (transformations/(user-specified-case-trans/selected * 2 - 1)) ]
        config-separator [
            separator-type (separator-types/(user-specified-separator-type/selected * 2 - 1))
            (either user-specified-separator-type/selected = random-character [
                reduce [ 'chosen-from (user-specified-random-separator-char/text) ] ] [
                reduce [ 'character (user-specified-specified-separator-char/text) ] ]) ]
        config-padding-digits [
            digits-before (padding-digits/(user-specified-padding-digits-before/selected * 2 - 1))
            digits-after (padding-digits/(user-specified-padding-digits-after/selected * 2 - 1)) ]
        config-padding-symbols [
            padding-type (padding-types/(user-specified-padding-type/selected * 2 - 1))
            (either user-specified-padding-type/selected = fixed-padding [
                reduce [
                    'symbols-before (padding-digits/(user-specified-fixed-padding-before/selected * 2 - 1))
                    'symbols-after (padding-digits/(user-specified-fixed-padding-after/selected * 2 - 1))
                    'padding-character (padding-characters/(user-specified-fixed-padding-character/selected * 2 - 1))
                    either (user-specified-padding-type/selected = fixed-padding) and
                           (user-specified-fixed-padding-character/selected = random-character) [
                        reduce [ 'chosen-from (user-specified-fixed-padding-alphabet/text) ] ] [
                        reduce [ 'character (user-specified-fixed-padding-specified-character/text) ] ] ]
             ] [
                reduce [
                    'pad-to-length (user-specified-adaptive-padding-length/text)
                    'padding-character (user-specified-adaptive-padding-character/text)
                    either (user-specified-padding-type/selected = adaptive-padding) and
                           (user-specified-adaptive-padding-character/selected = random-character) [
                        reduce [ 'chosen-from (user-specified-adaptive-padding-alphabet/text) ] ] [
                        reduce [ 'character (user-specified-adaptive-padding-specified-character/text) ] ] ] ]
             ) ]
        ]
]

view/flags [
    title "Password Generation"

    below

    group-box "Presets" [
        across
        origin 20x20
        button "APPLEID"   [ apply-preset 'apple-id   ]
        button "DEFAULT"   [ apply-preset 'default    ]
        button "NTLM"      [ apply-preset 'ntlm       ]
        button "SECURITYQ" [ apply-preset 'security-q ] return
        button "WEB16"     [ apply-preset 'web-16     ]
        button "WEB32"     [ apply-preset 'web-32     ]
        button "WIFI"      [ apply-preset 'wifi       ]
        button "XKCD"      [ apply-preset 'xkcd       ] ]

    group-box "Settings" [
        origin 20x20

        group-box "WORDS" [ across
            origin 20x20

            text "Dictionary:"
            user-specified-dictionary: drop-down focus select 1 data [ "English" ]

            text "Number of Words:"
            user-specified-word-count: drop-down select 1 35x1 data word-counts
            return

            text "Minimum Length:"
            user-specified-min-len: drop-down select 1 35x1 data word-lengths

            text "Maximum Length:"
            user-specified-max-len: drop-down select 1 35x1 data word-lengths
        ] return

        group-box "TRANSFORMATIONS" [ across
            origin 20x20
            text "Case Transformation:" return
            user-specified-case-trans: drop-down select 1 data transformations
        ] return

        group-box "SEPARATOR" [ across
            origin 20x20
            text "Type:"
            user-specified-separator-type:
                drop-down select 1 data separator-descriptions
            text "Separator Alphabet:" react [
                face/visible?: user-specified-separator-type/selected = random-character ]
            user-specified-random-separator-char:
                field "!@$%^^&*-_+=:|~?/.;" react [
                    face/visible?: user-specified-separator-type/selected = random-character ]
            text "Character:" react [
                face/visible?: user-specified-separator-type/selected = specified-character ]
            user-specified-specified-separator-char:
                field 35 "-" react [
                    face/visible?: user-specified-separator-type/selected = specified-character ]
        ] return

        group-box "PADDING DIGITS" [ across
            origin 20x20
            text "Symbols Before:"
            user-specified-padding-digits-before: drop-down "2" 35x1 data padding-digits
            text "Symbols After:"
            user-specified-padding-digits-after: drop-down "2" 35x1 data padding-digits
        ] return

        group-box "PADDING SYMBOLS" [ across
            origin 20x20
            text "Padding Type:"
            user-specified-padding-type: drop-down select 1 data padding-descriptions
            text "Symbols Before:" react [
                face/visible?: user-specified-padding-type/selected = fixed-padding ]
            user-specified-fixed-padding-before:
                drop-down "1" 35x1 data padding-digits react [
                    face/visible?: user-specified-padding-type/selected = fixed-padding ]
            text "Symbols After:" react [
                face/visible?: user-specified-padding-type/selected = fixed-padding ]
            user-specified-fixed-padding-after:
                drop-down "1" 35x1 data padding-digits react [
                    face/visible?: user-specified-padding-type/selected = fixed-padding ]
            return
            text "Padding Character:" react [
                face/visible?: user-specified-padding-type/selected = fixed-padding ]
            user-specified-fixed-padding-character: drop-down select 1
                data padding-characters-descriptions react [
                    face/visible?: user-specified-padding-type/selected = fixed-padding ]
            text "Padding Character Alphabet:" react [
                face/visible?: (user-specified-padding-type/selected = fixed-padding) and
                    (user-specified-fixed-padding-character/selected = random-character) ]
            user-specified-fixed-padding-alphabet: field "!@$%^^&*-_+=:|~?/.;" react [
                face/visible?: (user-specified-padding-type/selected = fixed-padding) and
                    (user-specified-fixed-padding-character/selected = random-character) ]
            text "Padding Character:" react [
                face/visible?: (user-specified-padding-type/selected = fixed-padding) and
                    (user-specified-fixed-padding-character/selected = specified-character) ]
            user-specified-fixed-padding-specified-character: field 35 "*" react [
                face/visible?: (user-specified-padding-type/selected = fixed-padding) and
                    (user-specified-fixed-padding-character/selected = specified-character) ]
            text "Pad to Length:" react [
                face/visible?: user-specified-padding-type/selected = adaptive-padding ]
            user-specified-adaptive-padding-length: field 70 "63" react [
                face/visible?: user-specified-padding-type/selected = adaptive-padding ]
            return
            text "Padding Character:" react [
                face/visible?: user-specified-padding-type/selected = adaptive-padding ]
            user-specified-adaptive-padding-character: drop-down select 1
                data padding-characters-descriptions react [
                    face/visible?: user-specified-padding-type/selected = adaptive-padding ]
            text "Padding Character Alphabet:" react [
                face/visible?: (user-specified-padding-type/selected = adaptive-padding) and
                    (user-specified-adaptive-padding-character/selected = random-character) ]
            user-specified-adaptive-padding-alphabet: field "!@$%^^&*-_+=:|~?/.;" react [
                face/visible?: (user-specified-padding-type/selected = adaptive-padding) and
                    (user-specified-adaptive-padding-character/selected = random-character) ]
            text "Padding Character:" react [
                face/visible?: (user-specified-padding-type/selected = adaptive-padding) and
                    (user-specified-adaptive-padding-character/selected = specified-character) ]
            user-specified-adaptive-padding-specified-character: field 35 "*" react [
                face/visible?: (user-specified-padding-type/selected = adaptive-padding) and
                    (user-specified-adaptive-padding-character/selected = specified-character) ]
        ]
    ]

    group-box "GENERATE PASSWORD" [ across
        origin 20x20
        button "Generate Password(s)" on-up [
            results: generate-passwords
                collect-config-settings
                (index? find password-counts password-count/text) / 2

            resulting-passwords/text: copy ""
            foreach p results/passwords [
                append resulting-passwords/text p
                append resulting-passwords/text "^/" ]

            resulting-entropy/text: copy ""
            foreach e results/entropy [
                append resulting-entropy/text e
                append resulting-entropy/text "^/" ] ]
        text "Number of Passwords to Generate"
        password-count: drop-down "1" 35x1 data password-counts return
        resulting-passwords: area
        resulting-entropy: area ]
] 'resize

;; vim:ft=red

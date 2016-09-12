Red [ Title: "Blind Entropy Calculations"
      Author: "Jeff Maner"
      Date: "2016-08-23"
]

entropy-blind: func [
    alphabet-size           [ integer! ] "Size of the alphabet resulting from configuration."
    minimum-password-length [ integer! ] "Minimum length of password generated from configuration."
] [
    log-2 alphabet-size ** minimum-password-length
]

calculate-alphabet-size: func [
    config [ block! ]

    /local size symbol?
] [
    size: switch/default config/config-transformations/case-transformation [
        'no-transformation [ 26 ]
        'lower-case        [ 26 ]
        'upper-case        [ 26 ]
        'tail-letter       [ 26 ]
        'alternating-word  [ 52 ]
        'first-letter      [ 52 ]
        'random-word       [ 52 ] ]
                           [  0 ]

    symbol?: false

    unless (error? try [ config/config-separator/separator-type ])
       and (not config/config-separator/separator-type = 'no-separator) [
        symbol?: symbol?
              or (config/config-separator/separator-type = 'random-character)
              or (config/config-separator/separator-type = 'specified-character) ]
    unless (error? try [ config/config-padding-symbols/padding-type ])
       and (not config/config-padding-symbols/padding-type = 'no-padding) [
        unless (error? try [ config/config-padding-symbols/padding-character ]) [
            unless error? try [ config/config-padding-symbols/symbols-before
                                config/config-padding-symbols/symbols-after ] [
                symbol?: symbol?
                      or (config/config-padding-symbols/padding-character = 'random-character)
                      or (config/config-padding-symbols/padding-character = 'specified-character)
                     and ((config/config-padding-symbols/symbols-before > 0)
                       or (config/config-padding-symbols/symbols-after  > 0)) ] ] ]

    if symbol? [ size: size + 33 ]

    unless error? try [ config/config-padding-digits/digits-before
                        config/config-padding-digits/digits-after ] [
        if (config/config-padding-digits/digits-before > 0) or
           (config/config-padding-digits/digits-after  > 0) [
            size: size + 10 ] ]

    size
]

calculate-minimum-password-length: func [
    config [ block! ]

    /local size
] [
    size: config/config-words/word-count * config/config-words/minimum-length

    unless (error? try [ config/config-separator/separator-type ])
       and (not config/config-separator/separator-type = 'no-separator) [
        size: size + 1 ]

    unless (error? try [ config/config-padding-symbols/padding-type ])
       and (not config/config-padding-symbols/padding-type = 'no-padding) [
        unless (error? try [ config/config-padding-symbols/padding-character ]) [
            unless error? try [ config/config-padding-symbols/symbols-before
                                config/config-padding-symbols/symbols-after ] [
                if (config/config-padding-symbols/padding-character = 'random-character) or
                   (config/config-padding-symbols/padding-character = 'specified-character) and
                   ((config/config-padding-symbols/symbols-before > 0) or
                    (config/config-padding-symbols/symbols-after  > 0)) [
                    size: size + config/config-padding-symbols/symbols-before
                               + config/config-padding-symbols/symbols-after
                               + config/config-words/word-count ] ] ] ]

    unless error? try [ config/config-padding-digits/digits-before
                        config/config-padding-digits/digits-after ] [
            size: size + config/config-padding-digits/digits-before
                       + config/config-padding-digits/digits-after ]

    size
]

;; vim:ft=red

Red [ Title: "Seen Entropy Calculations"
      Author: "Jeff Maner"
      Date: "2016-08-23"
]

permutation-count: func [
    possible-states [ integer! ]
    number-of-times [ integer! ]
] [
    possible-states ** number-of-times
]

entropy-seen: func [
    filtered-words [ series! ] "Words of specified length from specified dictionary."
    config [ block! ]

    /local case-multiplier words-permutations separator-permutations
           padding-digits-permutations padding-symbols-permutations
           permutations
] [
    case-multiplier: switch/default config/config-transformations/case-transformation [
        'alternating-word [ 2 ]
        'random-word      [ 2 ] ]
                          [ 1 ]

    words-permutations: permutation-count (case-multiplier * length? filtered-words) config/config-words/word-count

    separator-permutations: either none? config/config-separator/chosen-from [
        permutation-count 1 1 ] [
        permutation-count (length? config/config-separator/chosen-from) 1 ]

    padding-symbols-permutations: either error? try [ config/config-padding-symbols/chosen-from ] [
        permutation-count 1 1 ] [
        permutation-count (length? config/config-padding-symbols/chosen-from) 1 ]

    padding-digits-permutations: permutation-count 10 (config/config-padding-digits/digits-before + config/config-padding-digits/digits-after)

    permutations: words-permutations * separator-permutations * padding-symbols-permutations * padding-digits-permutations

    log-2 permutations
]

;; vim:ft=red

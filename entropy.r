Red [ Title: "Entropy Calculations"
      Author: "Jeff Maner"
      Date: "2016-08-23"
      Notes: [ { Entropy calculations are off. One reason is Red's apparent inability
to handle big numbers. }
               { http://bbusschots.github.io/hsxkpasswd/XKPasswd/pod.html } ]
]

do load %bignumbers.r
do load %entropy-blind.r
do load %entropy-seen.r

blind-entropy: func [
    config [ block! ]
] [
    alphabet-size: calculate-alphabet-size config
    minimum-password-length: calculate-minimum-password-length config

    entropy-blind alphabet-size minimum-password-length
]

seen-entropy: func [
    filtered-words [ series! ]
    config [ block! ]
] [
    entropy-seen filtered-words config
]

;; vim:ft=red

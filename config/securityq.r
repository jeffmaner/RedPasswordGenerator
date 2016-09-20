Red [ Title: "Password Generator Security Question Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        176 bits
                       generate-password.r 188 bits ]
      Seen-Entropy:  [ xkpasswd.net         62 bits
                       generate-password.r  62 bits ]
]

config-words:
[
    dictionary %dict/EN_sample.txt
    word-count 6
    minimum-length 4
    maximum-length 8
]

config-transformations:
[
    case-transformation 'no-transformation
]

config-separator:
[
    separator-type 'specified-character
    character #" "
]

config-padding-digits:
[
    digits-before 0
    digits-after  0
]

config-padding-symbols:
[
    padding-type 'fixed-padding
    symbols-before 0
    symbols-after 1
    padding-character 'random-character
    chosen-from [ #"." #"!" #"?" ]
]

;; vim:ft=red

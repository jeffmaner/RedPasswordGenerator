Red [ Title: "Password Generator XKCD Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        121 bits
                       generate-password.r 216 bits ]
      Seen-Entropy:  [ xkpasswd.net        108 bits
                       generate-password.r  44 bits ]
]

config-words:
[
    dictionary %sample_dict_EN.txt
    word-count 4
    minimum-length 4
    maximum-length 8
]

config-transformations:
[
    case-transformation 'random-word
]

config-separator:
[
    separator-type 'specified-character
    character #"-"
]

config-padding-digits:
[
    digits-before 0
    digits-after  0
]

config-padding-symbols:
[
    padding-type 'no-padding
]

;; vim:ft=red

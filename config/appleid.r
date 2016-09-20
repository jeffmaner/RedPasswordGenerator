Red [ Title: "Password Generator AppleID Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        164 bits
                       generate-password.r 164 bits ]
      Seen-Entropy:  [ xkpasswd.net         74 bits
                       generate-password.r  48 bits ]
]

config-words:
[
    dictionary %dict/EN_sample.txt
    word-count 3
    minimum-length 5
    maximum-length 7
]

config-transformations:
[
    case-transformation 'random-word
]

config-separator:
[
    separator-type 'random-character
    chosen-from [ #"-" #":" #"." #"," ]
]

config-padding-digits:
[
    digits-before 2
    digits-after  2
]

config-padding-symbols:
[
    padding-type 'fixed-padding
    symbols-before 1
    symbols-after 1
    padding-character 'random-character
    chosen-from [ #"!" #"@" #"&" #"?" ]
]

;; vim:ft=red

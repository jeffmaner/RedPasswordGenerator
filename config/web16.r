Red [ Title: "Password Generator Web16 Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        102 bits
                       generate-password.r 115 bits ]
      Seen-Entropy:  [ xkpasswd.net         58 bits
                       generate-password.r  35 bits ]
]

config-words:
[
    dictionary %dict/EN_sample.txt
    word-count 3
    minimum-length 4
    maximum-length 4
]

config-transformations:
[
    case-transformation 'random-word
]

config-separator:
[
    separator-type 'random-character
    chosen-from [ #"-" #"+" #"=" #"." #"*" #"_" #"|" #"~" #"," ]
]

config-padding-digits:
[
    digits-before 0
    digits-after  0
]

config-padding-symbols:
[
    padding-type 'fixed-padding
    symbols-before 1
    symbols-after 1
    padding-character 'random-character
    chosen-from [ #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"+" #"=" #":" #"|" #"~" #"?" ]
]

;; vim:ft=red

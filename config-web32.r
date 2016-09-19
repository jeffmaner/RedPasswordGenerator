Red [ Title: "Password Generator Web32 Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        177 bits
                       generate-password.r 177 bits ]
      Seen-Entropy:  [ xkpasswd.net         57 bits
                       generate-password.r  61 bits ]
]

config-words:
[
    dictionary %dict_EN_sample.txt
    word-count 4
    minimum-length 4
    maximum-length 5
]

config-transformations:
[
    case-transformation 'alternating-word
]

config-separator:
[
    separator-type 'random-character
    chosen-from [ #"-" #"+" #"=" #"." #"*" #"_" #"|" #"~" #"," ]
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
    chosen-from [ #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"+" #"=" #":" #"|" #"~" #"?" ]
]

;; vim:ft=red

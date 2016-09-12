Red [ Title: "Password Generator Wifi Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        413 bits
                       generate-password.r 216 bits ]
      Seen-Entropy:  [ xkpasswd.net        156 bits
                       generate-password.r 100 bits ]
]

config-words:
[
    dictionary %sample_dict_EN.txt
    word-count 6
    minimum-length 4
    maximum-length 8
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
    digits-before 4
    digits-after  4
]

config-padding-symbols:
[
    padding-type 'adaptive-padding
    pad-to-length 63
    padding-character 'random-character
    chosen-from [ #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"+" #"=" #":" #"|" #"~" #"?" ]
]

;; vim:ft=red

Red [ Title: "Password Generator Default Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        157 bits
                       generate-password.r 157 bits ]
      Seen-Entropy:  [ xkpasswd.net         52 bits
                       generate-password.r  55 bits ]
]

config-words:
[
    dictionary %sample_dict_EN.txt
    word-count 3
    minimum-length 4
    maximum-length 8
]

config-transformations:
[
    case-transformation 'alternating-word
]

config-separator:
[
    separator-type 'random-character
    chosen-from [
        #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"-" #"_" #"+" #"=" #":" #"|"
        #"~" #"?" #"/" #"." #";" ]
]

config-padding-digits:
[
    digits-before 2
    digits-after  2
]

config-padding-symbols:
[
    padding-type 'fixed-padding
    padding-character 'random-character
    symbols-before 2
    symbols-after 2
    chosen-from [
        #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"-" #"_" #"+" #"=" #":" #"|"
        #"~" #"?" #"/" #"." #";" ]
]

;; vim:ft=red

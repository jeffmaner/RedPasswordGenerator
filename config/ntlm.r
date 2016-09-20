Red [ Title: "Password Generator NTLM Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-18"
      Inspired-by: https://xkpasswd.net/s/
      Blind-Entropy: [ xkpasswd.net        91 bits
                       generate-password.r 91 bits ]
      Seen-Entropy:  [ xkpasswd.net        26 bits
                       generate-password.r 26 bits ]
]

config-words:
[
    dictionary %dict/EN_sample.txt
    word-count 2
    minimum-length 5
    maximum-length 5
]

config-transformations:
[
    case-transformation 'tail-letter
]

config-separator:
[
    separator-type 'random-character
    chosen-from [ #"*" #"-" #"_" #"+" #"=" #"|" #"~" #"." #"," ]
]

config-padding-digits:
[
    digits-before 1
    digits-after  0
]

config-padding-symbols:
[
    padding-type 'fixed-padding
    symbols-before 0
    symbols-after 1
    padding-character 'random-character
    chosen-from [
        #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"+" #"=" #":" #"|" #"~" #"?" ]
]

;; vim:ft=red

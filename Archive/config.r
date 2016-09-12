Red [ Title: "Password Generator Configuration"
      Author: "Jeff Maner"
      Date: "2016-08-16"
      Inspired-by: https://xkpasswd.net/s/
]

word-counts: naturals/from/to 2 10
word-lengths: naturals/from/to 4 12

transformations:
[
    no-transformation "-none-"
    alternating-word "alternating WORD case"
    first-letter "Capitalize First Letter"
    tail-letter "cAPITALIZE eVERY lETTER eXCEPT tHE fIRST"
    lower-case "lower case"
    upper-case "UPPER CASE"
    random-word "EVERY word randomly CAPITALIZED or NOT"
]

separator-types:
[
    no-separator [ description: "-none-" ]
    random-character [
        description "Random Character"
        alphabet [
            #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"-" #"_" #"+" #"=" #":" #"|"
            #"~" #"?" #"/" #"." #";" ] ]
    specified-character [
        description "Specified Character"
        character #"-" ]
]

padding-digits: [ 0 1 2 3 4 5 ]

padding-types:
[
    no-padding [ description "-none-" ]
    fixed-padding [
        description "Fixed"
        symbols-before padding-digits/3
        symbols-after  padding-digits/3 ]
    adaptive-padding [
        description "Adaptive"
        pad-to-length 12 ]
]

padding-characters:
[
    use-separator-character [ description "Use Separator Character" ]
    random-character [
        description "Random Character"
        alphabet [
            #"!" #"@" #"$" #"%" #"^^" #"&" #"*" #"-" #"_" #"+" #"=" #":" #"|"
            #"~" #"?" #"/" #"." #";" ] ]
    specified-character [
        description "Specified Character"
        character #"*" ]
]

;; vim:ft=red

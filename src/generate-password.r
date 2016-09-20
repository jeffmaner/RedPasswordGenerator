Red [ Title: "Password Generator"
      Author: "Jeff Maner"
      Date: "2016-08-15"
      Inspired-by: https://xkpasswd.net/s/
      Usage: { "do/args %src/generate-password.r [ config %config/default.r passwords 3 ]"
               "do/args %src/generate-password.r [ config %config/appleid.r passwords 2 ]"
               "do/args %src/generate-password.r [ config %config/xkcd.r passwords 5 ]"
               "do/args %src/generate-password.r [ config %config/securityq.r ]" }
      Notes: [ { Calling do/args %src/generate-password.r [ config <config.r> passwords 3 ]
and then do/args %src/generate-password.r [ config <config.r> ]
will result in three passwords generated. }
             { http://bbusschots.github.io/hsxkpasswd/XKPasswd/pod.html }
             { Entropy calculations are off. One reason is Red's apparent inability
to handle big numbers. } ]
]

;; Running the script will change-dir into %src. Go back up.
change-dir %..

config-file: none
passwords: none

unless none? system/script/args [
    parse system/script/args [ some [ 'config    set config-file file!
                                    | 'passwords set passwords   integer! ] ] ]

do load %src/shared/ancillary.r

do load either none? config-file [ %config/default.r ] [ config-file ]

passwords: either none? passwords [ 1 ] [ passwords ]

config: compose/deep [
    config-words [(config-words)]
    config-transformations [(config-transformations)]
    config-separator [(config-separator)]
    config-padding-digits [(config-padding-digits)]
    config-padding-symbols [(config-padding-symbols)] ]
words: read/lines config/config-words/dictionary
remove-each line words [ #"#" = first line ]

filter-words: func [
    words [ series! ]
    config [ block! ]

    /local words-needed minimum-word-length maximum-word-length filtered-words word n
] [
    words-needed: do config/config-words/word-count
    minimum-word-length: do config/config-words/minimum-length
    maximum-word-length: do config/config-words/maximum-length

    filtered-words: copy words
    remove-each word filtered-words [
        n: length? word
        (n < minimum-word-length) or
        (n > maximum-word-length) ]

    filtered-words
]

filtered-words: filter-words words config
                        
do load %src/shared/password.r
generated-passwords: copy []
foreach n naturals/to passwords [
    append generated-passwords generate-password filtered-words config ]

foreach password generated-passwords [ print password ]

do load %src/shared/entropy.r
print [ "Blind Entropy: " to integer! blind-entropy config ]
print [ "Seen Entropy: " to integer! seen-entropy filtered-words config ]

;; vim:ft=red

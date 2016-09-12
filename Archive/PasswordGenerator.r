Red [ Title: "Password Generator"
      Author: "Jeff Maner"
      Date: 2016-08-15
      Inspired-by: https://xkpasswd.net/s/
]

do load %config.r

words: read/lines config-words/Dictionary
remove-each line words [ #"#" = first line ]

random/only

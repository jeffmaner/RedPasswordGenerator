Red [ Title:  "Ancillary Functions to Password Generation"
      Author: "Jeff Maner"
      Date:   "2016-08-17"
]

naturals: func [
    "Returns a sequence of Natural numbers."

    /from base  "Start enumeration of Naturals from base or one."
    /to   limit "Enumerate Naturals up to limit or 2 ** 32 - 1."

    /local result n
] [
    b: either base  [base]  [1]
    m: either limit [limit] [2 ** 32 - 1]

    result: copy []

    repeat n (m - b + 1) [append result n + b - 1]

    result
]

map-each: func [
    "Kind-of implements Rebol's map-each which Red doesn't have yet."

    x [ word! integer! string! ]
    xs [ series! ]
    f [ block! ]

    /local y ys
] [
    ys: copy []

    foreach y xs [ append ys (f y) ]

    ys
]

join: func [
    "Implements Rebol's join which Red doesn't have."

    x [ string! ]
    xs [ series! ]

    /local y ys
] [
    ys: copy ""

    foreach y xs [
        append ys y
        unless x = "" [
            append ys x ] ]

    either x = "" [
        ys ] [
        take/part ys ((length? ys) - 1) ]
]

;; vim:ft=red

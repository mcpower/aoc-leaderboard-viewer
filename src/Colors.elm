module Colors exposing (..)


seriesColors : List String
seriesColors =
    [ colors.red
    , colors.yellowGreen
    , colors.azure
    , colors.darkBlue
    , colors.pink
    , colors.orange
    , colors.green
    , colors.blue
    , colors.violet
    ]


colorsList : Int -> List String
colorsList count =
    let
        repeats =
            ceiling (toFloat count / toFloat (List.length seriesColors))
    in
        seriesColors
            |> List.repeat repeats
            |> List.concat
            |> List.take count


colors :
    { red : String
    , yellowGreen : String
    , azure : String
    , darkBlue : String
    , pink : String
    , orange : String
    , green : String
    , blue : String
    , violet : String
    , grey : String
    , darkGrey : String
    , transparent : String
    }
colors =
    { red = semitransparent "255,146,112"
    , yellowGreen = semitransparent "161,188,0"
    , azure = semitransparent "0,197,197"
    , darkBlue = semitransparent "146,173,255"
    , pink = semitransparent "255,139,178"
    , orange = semitransparent "255,149,57"
    , green = semitransparent "0,205,50"
    , blue = semitransparent "0,191,245"
    , violet = semitransparent "233,140,255"
    , grey = "#e3e3e3"
    , darkGrey = "#a3a3a3"
    , transparent = "transparent"
    }


semitransparent : String -> String
semitransparent color =
    "rgba(" ++ color ++ ",0.5)"

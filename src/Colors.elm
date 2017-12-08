module Colors exposing (..)


seriesColors : List String
seriesColors =
    [ colors.red
    , colors.blue
    , colors.brown
    , colors.green
    , colors.darkRed
    , colors.orange
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
    { green : String
    , orange : String
    , brown : String
    , red : String
    , darkRed : String
    , blue : String
    , violet : String
    , grey : String
    , darkGrey : String
    }
colors =
    { red = "#ed5353"
    , darkRed = "#7a0000"
    , orange = "#f37329"
    , brown = "#ad5f00"
    , green = "#68b723"
    , blue = "#3689e6"
    , violet = "#7a36b1"
    , grey = "#e3e3e3"
    , darkGrey = "#a3a3a3"
    }

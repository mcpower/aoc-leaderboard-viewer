module Colors exposing (..)


colorsList : Int -> List String
colorsList count =
    let
        possibilities =
            [ colors.red
            , colors.orange
            , colors.green
            , colors.blue
            ]

        repeats =
            ceiling (toFloat count / toFloat (List.length possibilities))
    in
        possibilities
            |> List.repeat repeats
            |> List.concat
            |> List.take count


colors :
    { green : String
    , orange : String
    , red : String
    , blue : String
    , grey : String
    , darkGrey : String
    }
colors =
    { red = "#d53e4f"
    , orange = "#fc8d59"
    , green = "#99d594"
    , blue = "#3288bd"
    , grey = "#e3e3e3"
    , darkGrey = "#a3a3a3"
    }

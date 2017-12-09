module View.Plot.Text exposing (..)

import Svg exposing (Attribute)
import Svg.Attributes as SA
import Colors exposing (colors)


attributes : List (Attribute msg)
attributes =
    [ SA.fill colors.darkGrey
    , SA.fontSize "10px"
    ]


italic : String
italic =
    "font-style: italic"


alignRight : String
alignRight =
    "text-anchor: end"


styles : List String -> Attribute msg
styles styles =
    styles
        |> String.join ";"
        |> SA.style

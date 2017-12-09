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


color : String -> String
color colorString =
    "fill: " ++ colorString


yOffset : Float -> Attribute msg
yOffset offset =
    SA.y (toString offset ++ "px")


styles : List String -> Attribute msg
styles styles =
    styles
        |> String.join ";"
        |> SA.style

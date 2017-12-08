module View.Plot.Text exposing (attributes, italic)

import Svg exposing (Attribute)
import Svg.Attributes as SA
import Colors exposing (colors)


attributes : List (Attribute msg)
attributes =
    [ SA.fill colors.darkGrey
    , SA.fontSize "10px"
    ]


italic : Attribute msg
italic =
    SA.style "font-style: italic;"

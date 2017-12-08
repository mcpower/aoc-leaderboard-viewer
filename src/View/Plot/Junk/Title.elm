module View.Plot.Junk.Title exposing (title)

import Types exposing (..)
import Plot as P exposing (JunkCustomizations)
import View.Plot.Text as Text
import View.Name as View
import Day exposing (startOfAoC, day)
import Svg exposing (Svg)


title : String -> Float -> JunkCustomizations Msg
title titleString y =
    P.junk
        (svg titleString)
        (startOfAoC + day / 8)
        y


svg : String -> Svg msg
svg titleString =
    P.viewLabel
        (Text.italic :: Text.attributes)
        titleString

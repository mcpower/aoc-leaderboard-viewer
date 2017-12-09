module View.Plot.Junk.Title exposing (title)

import Types exposing (..)
import Plot as P exposing (JunkCustomizations)
import View.Plot.Text as Text
import Day exposing (day)
import Svg exposing (Svg)


title : String -> Float -> JunkCustomizations Msg
title titleString y =
    P.junk
        (svg titleString)
        1.1
        (y - 0.4 * day)


svg : String -> Svg msg
svg titleString =
    P.viewLabel
        (Text.styles [ Text.italic ] :: Text.attributes)
        titleString

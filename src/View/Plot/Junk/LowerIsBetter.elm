module View.Plot.Junk.LowerIsBetter exposing (lowerIsBetter)

import View.Plot.Text as Text
import Types exposing (..)
import Day exposing (day)
import Plot as P
    exposing
        ( PlotSummary
        , JunkCustomizations
        )


lowerIsBetter : PlotSummary -> JunkCustomizations Msg
lowerIsBetter summary =
    P.junk
        (P.viewLabel
            (Text.styles [ Text.italic, Text.alignRight ] :: Text.attributes)
            "lower is better (puzzle done sooner)"
        )
        (summary.x.max - 0.05)
        (summary.y.min + day / 7)

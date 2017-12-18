module View.Plot.PlotCustomizations exposing (plotCustomizations)

import Types exposing (..)
import Day
    exposing
        ( startOfAoC
        , endOfAoC
        , comfortableRange
        , day
        )
import DayStar
import View.Plot.Axis exposing (horizontalAxis)
import View.Plot.Grid as Grid
import View.Plot.Hint as Hint
import View.Date as Date
import Plot as P
    exposing
        ( PlotCustomizations
        , PlotSummary
        , JunkCustomizations
        , defaultSeriesPlotCustomizations
        )


plotCustomizations :
    Model
    -> Data
    -> (PlotSummary -> List (JunkCustomizations Msg))
    -> PlotCustomizations Msg
plotCustomizations model data junk =
    let
        maxDate =
            Date.max data

        maxDayStar =
            DayStar.max data
    in
        { defaultSeriesPlotCustomizations
            | -- on-hover tooltip
              hintContainer = P.flyingHintContainer Hint.containerInner model.hover

            -- width-to-height ratio can be adjusted by this `height` field
            , height = 300

            -- title (and other custom SVG if needed)
            , junk = withGlobalJunk junk

            -- vertical and horizontal grid
            , grid =
                -- on every star
                { horizontal = Grid.date maxDate

                -- we want the gridlines to show everyday midnight EST == 05:00 GMT
                -- (problem release time)
                , vertical = Grid.dayStar model.hover maxDayStar
                }

            -- what values will show (and how) on the horizontal axis
            -- (ie. every midnight EST if we're not hovering;
            -- only the precise solution date if we are)
            , horizontalAxis = horizontalAxis model.hover maxDayStar

            -- if something clips, look here
            , margin =
                { top = 20
                , bottom = 30
                , left = 80
                , right = 30
                }

            -- zoom parameters for the plot
            -- the "minus something" are for a padding between plot and axis
            , toRangeLowest = always (1.0 - 0.2)
            , toRangeHighest = always maxDayStar
            , toDomainLowest = always (startOfAoC - (day / 2))
            , toDomainHighest = always maxDate

            -- turn on hover on the whole vertical lines
            , onHover = Just Hover
        }


withGlobalJunk :
    (PlotSummary -> List (JunkCustomizations Msg))
    -> PlotSummary
    -> List (JunkCustomizations Msg)
withGlobalJunk customJunk summary =
    customJunk summary

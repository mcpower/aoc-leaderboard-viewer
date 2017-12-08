module View.Plot.PlotCustomizations exposing (plotCustomizations)

import Types exposing (..)
import Day
    exposing
        ( startOfAoC
        , endOfAoC
        , comfortableRange
        )
import DayStar
import View.Plot.Axis exposing (horizontalAxis)
import View.Plot.Grid exposing (gridAlignedOnMidnightEST)
import DayStar
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
        maxDate : Float
        maxDate =
            data
                |> List.concatMap .completionTimes
                |> List.map (\( _, _, time ) -> time)
                |> List.maximum
                |> Maybe.withDefault endOfAoC
                |> comfortableRange
                |> Tuple.second
    in
        { defaultSeriesPlotCustomizations
            | -- on-hover tooltip
              hintContainer =
                P.flyingHintContainer
                    P.normalHintContainerInner
                    model.hover

            -- width-to-height ratio can be adjusted by this `height` field
            , height = 200

            -- title (and other custom SVG if needed)
            , junk = junk

            -- vertical and horizontal grid
            , grid =
                -- currently does automatically what we need
                -- TODO maybe in the future we'll scale it here?
                { horizontal = P.decentGrid

                -- we want the gridlines to show everyday midnight EST == 05:00 GMT
                -- (problem release time)
                , vertical = gridAlignedOnMidnightEST maxDate
                }

            -- what values will show (and how) on the horizontal axis
            -- (ie. every midnight EST if we're not hovering;
            -- only the precise solution date if we are)
            , horizontalAxis = horizontalAxis model.hover maxDate

            -- if something overlaps, look here
            , margin =
                { top = 10
                , bottom = 30
                , left = 60
                , right = 30
                }

            -- zoom parameters for the plot
            , toRangeLowest = always startOfAoC
            , toRangeHighest = always maxDate
            , toDomainLowest = always 1.0
            , toDomainHighest = always (DayStar.max data)
        }

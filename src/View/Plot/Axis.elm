module View.Plot.Axis
    exposing
        ( horizontalAxis
        , verticalAxis
        )

import Day exposing (..)
import DayStar
import View.DayStar as DayStar
import View.Plot.Text as Text
import View.Date exposing (formatDate)
import Date
import Plot as P
    exposing
        ( Point
        , Axis
        , AxisSummary
        , LabelCustomizations
        )


horizontalAxis : Maybe Point -> Float -> Axis
horizontalAxis hover maxDate =
    axis
        hover
        .x
        (Date.fromTime >> formatDate)
        (always (findTicks maxDate))


verticalAxis : Maybe Point -> Axis
verticalAxis hover =
    axis
        hover
        .y
        (DayStar.fromFloat >> DayStar.format)
        (P.interval 0 0.5)


axis : Maybe Point -> (Point -> Float) -> (Float -> String) -> (AxisSummary -> List Float) -> Axis
axis hover toValue makeString toTicks =
    P.customAxis <|
        \summary ->
            let
                ticks =
                    toTicks summary

                makeLabel position =
                    { position = position
                    , view =
                        position
                            |> makeString
                            |> P.viewLabel Text.attributes
                    }
            in
                { position = P.closestToZero
                , axisLine =
                    Just
                        { attributes = []
                        , start = startOfAoC
                        , end =
                            ticks
                                |> List.reverse
                                |> List.head
                                |> Maybe.withDefault endOfAoC
                        }
                , ticks = hoveredOrTicks hover toValue P.simpleTick ticks
                , labels = hoveredOrTicks hover toValue makeLabel ticks
                , flipAnchor = False
                }


hoveredOrTicks : Maybe Point -> (Point -> Float) -> (Float -> a) -> List Float -> List a
hoveredOrTicks hover toValue makeStuff ticks =
    hover
        |> Maybe.map (\p -> [ makeStuff (toValue p) ])
        |> Maybe.withDefault (List.map makeStuff ticks)

module View.Plot.Axis
    exposing
        ( horizontalAxis
        , verticalAxis
        )

import Day exposing (..)
import DayStar
import View.DayStar as DayStar
import View.Plot.Text as Text
import View.Date as Date
import Date
import Svg.Attributes as SA
import Colors exposing (colors)
import Plot as P
    exposing
        ( Point
        , Axis
        , AxisSummary
        , LabelCustomizations
        )


horizontalAxis : Maybe Point -> Float -> Axis
horizontalAxis hover maxDayStar =
    axis
        True
        hover
        ( 1.0, maxDayStar )
        .x
        (DayStar.fromFloat >> DayStar.format)
        (always (findTicks 1.0 maxDayStar 0.5))


verticalAxis : Bool -> Maybe Point -> Float -> Axis
verticalAxis showOnlyOneOnHover hover maxDate =
    axis
        showOnlyOneOnHover
        hover
        ( startOfAoC, maxDate )
        .y
        (Date.fromTime >> Date.format)
        (always (findTicks startOfAoC maxDate day))


axis : Bool -> Maybe Point -> ( Float, Float ) -> (Point -> Float) -> (Float -> String) -> (AxisSummary -> List Float) -> Axis
axis showOnlyOneOnHover hover ( min, max ) toValue makeString toTicks =
    -- TODO refactor or document
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
                        { attributes = [ SA.stroke colors.darkGrey ]
                        , start = min
                        , end =
                            ticks
                                |> List.reverse
                                |> List.head
                                |> Maybe.withDefault max
                        }
                , ticks =
                    if showOnlyOneOnHover then
                        hoveredOrTicks hover toValue P.simpleTick ticks
                    else
                        List.map P.simpleTick ticks
                , labels =
                    if showOnlyOneOnHover then
                        hoveredOrTicks hover toValue makeLabel ticks
                    else
                        List.map makeLabel ticks
                , flipAnchor = False
                }


hoveredOrTicks : Maybe Point -> (Point -> Float) -> (Float -> a) -> List Float -> List a
hoveredOrTicks hover toValue makeStuff ticks =
    hover
        |> Maybe.map (\p -> [ makeStuff (toValue p) ])
        |> Maybe.withDefault (List.map makeStuff ticks)

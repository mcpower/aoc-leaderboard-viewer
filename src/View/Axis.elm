module View.Axis exposing (axis)

import Day exposing (..)
import View.TextStyle as Text
import Plot as P
    exposing
        ( Point
        , Axis
        , AxisSummary
        , LabelCustomizations
        )


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

module View.Plot.Dot exposing (dot)

import Plot as P
    exposing
        ( Point
        , DataPoint
        , AxisSummary
        , LineCustomizations
        , TickCustomizations
        )
import Types exposing (..)
import Colors exposing (colors)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import View.Plot.Hint exposing (hint)


dot :
    DotOptions
    -> Maybe Point
    -> String
    -> String
    -> ( Float, Float )
    -> Maybe Int
    -> Int
    -> DataPoint Msg
dot dotOptions hover memberName color ( x, y ) maybeScore maxScore =
    { view = Just (square memberName color x y)
    , xLine =
        if dotOptions.xLine then
            hover |> Maybe.andThen (flashyLine x y)
        else
            Nothing
    , yLine =
        if dotOptions.yLine then
            hover |> Maybe.andThen (flashyLine x y)
        else
            Nothing
    , xTick =
        if dotOptions.xTick then
            hover |> Maybe.andThen (flashyTick x .x)
        else
            Nothing
    , yTick =
        if dotOptions.yTick then
            hover |> Maybe.andThen (flashyTick y .y)
        else
            Nothing
    , hint =
        onHovering
            (hint
                dotOptions.stripedHint
                memberName
                y
                x
                maybeScore
                maxScore
            )
            hover
            x
    , x = x
    , y = y
    }


flashyTick : Float -> (Point -> Float) -> Point -> Maybe TickCustomizations
flashyTick correctValue toValue hover =
    if toValue hover == correctValue then
        Just (P.simpleTick correctValue)
    else
        Nothing


flashyLine : Float -> Float -> Point -> Maybe (AxisSummary -> LineCustomizations)
flashyLine x y hover =
    if hover.x == x && hover.y == y then
        Just
            (P.fullLine
                [ SA.stroke colors.darkGrey
                , SA.strokeDasharray "3, 10"
                ]
            )
    else
        Nothing


square : String -> String -> Float -> Float -> Svg Msg
square memberName color x y =
    let
        width =
            5.0
    in
        S.rect
            [ SA.width (toString width)
            , SA.height (toString width)
            , SA.x (toString (-width / 2))
            , SA.y (toString (-width / 2))
            , SA.stroke colors.transparent
            , SA.strokeWidth "3px"
            , SA.fill color
            ]
            []


onHovering : a -> Maybe Point -> Float -> Maybe a
onHovering stuff hover x =
    hover
        |> Maybe.andThen
            (\p ->
                if p.x == x then
                    Just stuff
                else
                    Nothing
            )

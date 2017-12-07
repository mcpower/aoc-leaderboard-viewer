module View.Dot exposing (dot, invisibleDot)

import Plot as P
    exposing
        ( Point
        , DataPoint
        , AxisSummary
        , LineCustomizations
        , TickCustomizations
        )
import Types exposing (..)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Svg.Events as SE
import View.Hint exposing (hint)


dot : Maybe Point -> String -> String -> ( Float, Float ) -> Maybe Int -> DataPoint Msg
dot hover memberName color ( x, y ) awardedPoints =
    { view = Just (square memberName color x y)
    , xLine = hover |> Maybe.andThen (flashyLine x y)
    , yLine = hover |> Maybe.andThen (flashyLine x y)
    , xTick = hover |> Maybe.andThen (flashyTick x .x)
    , yTick = hover |> Maybe.andThen (flashyTick y .y)
    , hint = onHovering (hint memberName y x awardedPoints) hover x
    , x = x
    , y = y
    }


invisibleDot : Maybe Point -> ( Float, Float ) -> DataPoint Msg
invisibleDot hover ( x, y ) =
    { view = Nothing
    , xLine = hover |> Maybe.andThen (flashyLine x y)
    , yLine = hover |> Maybe.andThen (flashyLine x y)
    , xTick = Nothing
    , yTick = Nothing
    , hint = Nothing
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
                [ SA.stroke "#a3a3a3"
                , SA.strokeDasharray "2, 10"
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
            , SA.stroke "transparent"
            , SA.strokeWidth "3px"
            , SA.fill color
            , SE.onMouseOver (Hover (Just { x = x, y = y }))
            , SE.onMouseOut (Hover Nothing)
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

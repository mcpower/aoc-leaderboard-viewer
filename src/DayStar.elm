module DayStar exposing (toFloat, fromFloat)

import Types exposing (..)


toFloat : Day -> Star -> Float
toFloat day star =
    Basics.toFloat day + (Basics.toFloat star - 1) / 2


fromFloat : Float -> ( Day, Star )
fromFloat float =
    let
        day =
            floor float

        star =
            floor <| (float - Basics.toFloat day) * 2 + 1
    in
        ( day, star )

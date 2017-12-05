module View.DayStar
    exposing
        ( dayStarLabel
        , formatDayStar
        , dayStarToFloat
        , dayStarFromFloat
        , hintLabel
        )

import Plot as P
    exposing
        ( LabelCustomizations
        , Point
        )
import Types exposing (..)
import View.TextStyle as Text


dayStarLabel : Float -> LabelCustomizations
dayStarLabel position =
    { position = position
    , view =
        position
            |> dayStarFromFloat
            |> formatDayStar
            |> P.viewLabel Text.attributes
    }


hintLabel : Maybe Point -> (Point -> Float) -> List LabelCustomizations
hintLabel hover toValue =
    hover
        |> Maybe.map (\point -> [ dayStarLabel (toValue (point)) ])
        |> Maybe.withDefault []


formatDayStar : ( Day, Star ) -> String
formatDayStar ( day, star ) =
    "Day " ++ toString day ++ " Star " ++ toString star


dayStarToFloat : Day -> Star -> Float
dayStarToFloat day star =
    toFloat day + (toFloat star - 1) / 2


dayStarFromFloat : Float -> ( Day, Star )
dayStarFromFloat float =
    let
        day =
            floor float

        star =
            floor <| (float - toFloat day) * 2 + 1
    in
        ( day, star )

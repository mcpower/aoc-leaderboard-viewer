module View.Plot.Hint exposing (hint)

import Html as H exposing (Html)
import Html.Attributes as HA
import DayStar
import View.DayStar as DayStar
import View.Date exposing (..)
import View.DayStar exposing (..)


hint : String -> Float -> Float -> Maybe Int -> Int -> Html msg
hint name dayStarFloat solutionDate maybeScore maxScore =
    H.div
        [ HA.class "hint" ]
        [ H.div [] [ H.text name ]
        , H.div [] [ H.text <| DayStar.format <| DayStar.fromFloat <| dayStarFloat ]
        , H.div [] [ formatDateForHint solutionDate ]
        , formatScore maybeScore maxScore
        ]


formatScore : Maybe Int -> Int -> Html msg
formatScore maybeScore maxScore =
    maybeScore
        |> Maybe.map
            (\score ->
                H.div []
                    [ H.text <|
                        "Earned "
                            ++ toString score
                            ++ " out of "
                            ++ toString maxScore
                            ++ " point"
                            ++ (if score == 1 then
                                    ""
                                else
                                    "s"
                               )
                    ]
            )
        |> Maybe.withDefault (H.text "")

module View.Hint exposing (hint)

import Html as H exposing (Html)
import Html.Attributes as HA
import View.Date exposing (..)
import View.DayStar exposing (..)


hint : String -> Float -> Float -> Maybe Int -> Html msg
hint name dayStarFloat solutionDate awardedPoints =
    H.div
        [ HA.class "hint" ]
        [ H.div [] [ H.text name ]
        , H.div [] [ H.text <| formatDayStar <| dayStarFromFloat <| dayStarFloat ]
        , H.div [] [ formatDateForHint solutionDate ]
        , formatPoints awardedPoints
        ]


formatPoints : Maybe Int -> Html msg
formatPoints awardedPoints =
    awardedPoints
        |> Maybe.map
            (\points ->
                H.div []
                    [ H.text <|
                        "Earned " ++ toString points ++ " point"
                            ++ (if points == 1 then
                                    ""
                                else
                                    "s"
                               )
                    ]
            )
        |> Maybe.withDefault (H.text "")

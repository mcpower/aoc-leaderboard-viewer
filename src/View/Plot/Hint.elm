module View.Plot.Hint exposing (hint, containerInner)

import Date
import Html as H exposing (Html)
import Html.Attributes as HA
import View.Date as Date
import View.Score as Score


containerInner : Bool -> List (Html Never) -> Html Never
containerInner isLeft hints =
    H.div
        [ HA.class "container hint" ]
        (H.div [ HA.class "row row--header" ]
            [ H.div [ HA.class "col-sm col--member" ] [ H.text "Member" ]
            , H.div [ HA.class "col-sm col--solved" ] [ H.text "Solved" ]
            , H.div [ HA.class "col-sm col--score" ] [ H.text "Score" ]
            ]
            :: hints
        )


hint : Bool -> String -> Float -> Float -> Maybe Int -> Int -> Html msg
hint striped name solutionDate dayStarFloat maybeScore maxScore =
    H.div
        [ HA.class "row"
        , HA.style (Score.style striped maybeScore maxScore)
        ]
        [ H.div [ HA.class "col-sm col--member" ] [ H.text name ]
        , H.div [ HA.class "col-sm col--solved" ] [ H.text <| Date.formatWithSeconds <| Date.fromTime <| solutionDate ]
        , H.div [ HA.class "col-sm col--score" ] [ H.text <| Score.format maybeScore maxScore ]
        ]

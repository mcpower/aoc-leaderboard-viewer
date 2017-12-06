module View.Hint exposing (hint)

import Html as H exposing (Html)
import Html.Attributes as HA
import View.Date exposing (..)
import View.DayStar exposing (..)


hint : String -> Float -> Float -> Html msg
hint name dayStarFloat solutionDate =
    H.div
        [ HA.class "hint" ]
        [ H.div [] [ H.text name ]
        , H.div [] [ H.text <| formatDayStar <| dayStarFromFloat <| dayStarFloat ]
        , H.div [] [ formatDateForHint solutionDate ]
        ]

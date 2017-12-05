module View.Hint exposing (hint)

import Html as H exposing (Html)
import View.Date exposing (..)
import View.DayStar exposing (..)


hint : String -> Float -> Float -> Html msg
hint name dayStarFloat solutionDate =
    H.div []
        [ H.div [] [ H.text name ]
        , H.div [] [ H.text <| formatDayStar <| dayStarFromFloat <| dayStarFloat ]
        , H.div [] [ formatDateForHint solutionDate ]
        ]

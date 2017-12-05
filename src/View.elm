module View exposing (view)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import View.AllPlots as View
import Types exposing (..)


view : Model -> Html Msg
view model =
    H.div
        [ HA.id "page" ]
        [ H.div
            [ HA.id "top" ]
            [ H.h1 [] [ H.text "AoC private leaderboard viewer" ]
            , H.div []
                [ H.text "Go to some of your "
                , H.a [ HA.href "https://adventofcode.com/2017/leaderboard/private" ] [ H.text "private leaderboard" ]
                , H.text " URL + \".json\" and copy the result here!"
                ]
            , H.textarea
                [ HA.placeholder "Paste https://adventofcode.com/2017/leaderboard/private/view/<LEADERBOARD-ID>.json here"
                , HA.value model.json
                , HE.onInput SetJson
                ]
                []
            ]
        , H.div
            [ HA.id "plot" ]
            [ View.allPlots model ]
        ]

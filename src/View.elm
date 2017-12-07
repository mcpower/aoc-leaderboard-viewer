module View exposing (view)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import View.AllPlots as View
import Types exposing (..)
import RemoteData exposing (RemoteData(..))
import Example
import Date
import Date.Extra


view : Model -> Html Msg
view model =
    H.div
        [ HA.id "page" ]
        [ H.div
            [ HA.id "top" ]
            [ H.h1 [] [ H.text "AoC private leaderboard viewer" ]
            , H.div
                [ HA.class "inputs" ]
                [ H.label []
                    [ H.text "Leaderboard JSON URL:"
                    ]
                , H.input
                    [ HA.placeholder Example.url
                    , HA.value model.url
                    , HE.onInput SetUrl
                    ]
                    []
                ]
            , H.div
                []
                [ H.label []
                    [ H.text "Session cookie "
                    , H.a
                        [ HA.target "_blank"
                        , HA.href "https://i.imgur.com/75BC9zU.png"
                        ]
                        [ H.text "(what?!)" ]
                    , H.text ":"
                    ]
                , H.input
                    [ HA.placeholder Example.cookie
                    , HA.value model.cookie
                    , HE.onInput SetCookie
                    ]
                    []
                ]
            , H.div []
                [ H.button
                    [ HE.onClick (Fetch model.url model.cookie)
                    , HA.disabled (model.data == Loading)
                    ]
                    [ H.text "Fetch!" ]
                , case model.data of
                    Success _ ->
                        H.span [ HA.class "fetch-date" ]
                            [ H.text <|
                                "Fetched at "
                                    ++ (model.timeOfFetch
                                            |> Date.fromTime
                                            |> Date.Extra.toFormattedString "yyyy/MM/dd', 'HH:mm:ss"
                                       )
                            ]

                    _ ->
                        H.text ""
                ]
            ]
        , H.div
            [ HA.class "note" ]
            [ H.text "WARNING: clicking the \"Fetch!\" button sends your session cookie to my CORS proxy. I promise not to use it in any way, but... yeah, not ideal."
            ]
        , H.div
            [ HA.class "plot-area" ]
            [ if Example.shouldShow model then
                H.div [ HA.class "example-data-note" ] [ H.em [] [ H.text "↓↓↓ This is just example data, paste your own URL and cookie." ] ]
              else
                H.text ""
            , View.allPlots model
            ]
        ]

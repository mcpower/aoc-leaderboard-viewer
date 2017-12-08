module View exposing (view)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import View.Plot exposing (plot)
import Types exposing (..)
import RemoteData exposing (RemoteData(..))
import Example
import Date
import Date.Extra


view : Model -> Html Msg
view model =
    H.div [ HA.class "page" ]
        [ H.div [ HA.class "top" ]
            [ heading
            , inputs model
            , fetchButton model
            , radioButtons model
            ]
        , H.div [ HA.class "content" ]
            [ exampleWarning model
            , plot model
            ]
        ]


exampleWarningText : String
exampleWarningText =
    "↓↓↓ This is just example data, paste your own URL and cookie."


exampleWarning : Model -> Html Msg
exampleWarning model =
    if Example.shouldShow model then
        H.div
            [ HA.class "example-data-note" ]
            [ H.em [] [ H.text exampleWarningText ] ]
    else
        H.text ""


plotButton : Plot -> Plot -> Html Msg
plotButton plot currentlySelectedPlot =
    let
        label =
            plotLabel plot
    in
        H.label [ HA.class "plot-button" ]
            [ H.input
                [ HA.type_ "radio"
                , HA.name "type-of-plot"
                , HA.value label
                , HA.checked (plot == currentlySelectedPlot)
                , HE.onClick (ShowPlot plot)
                ]
                []
            , H.text label
            ]


plotLabel : Plot -> String
plotLabel plot =
    case plot of
        AllInOne ->
            "all members in one plot"

        OneForEachMember ->
            "one plot for each member"


heading : Html Msg
heading =
    H.h1 [] [ H.text "AoC private leaderboard viewer" ]


inputs : Model -> Html Msg
inputs model =
    H.div
        [ HA.class "inputs" ]
        [ H.div []
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
        ]


fetchButton : Model -> Html Msg
fetchButton model =
    H.div []
        [ H.button
            [ HE.onClick (Fetch model.url model.cookie)
            , HA.disabled (model.data == Loading)
            ]
            [ H.text "Fetch!" ]
        , case model.data of
            Success _ ->
                if not (Example.shouldShow model) then
                    H.span [ HA.class "fetch-date" ]
                        [ H.text <|
                            "Fetched at "
                                ++ (model.timeOfFetch
                                        |> Date.fromTime
                                        |> Date.Extra.toFormattedString "yyyy/MM/dd', 'HH:mm:ss"
                                   )
                        ]
                else
                    H.text ""

            _ ->
                H.text ""
        , H.div [ HA.class "note" ]
            [ H.text "WARNING: clicking the \"Fetch!\" button sends your session cookie to my CORS proxy. I promise not to use it in any way, but... yeah, not ideal."
            ]
        ]


radioButtons : Model -> Html Msg
radioButtons model =
    H.fieldset []
        [ H.legend [] [ H.text "Show plot:" ]
        , plotButton OneForEachMember model.plot
        , plotButton AllInOne model.plot
        ]

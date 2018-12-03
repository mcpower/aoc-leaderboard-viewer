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
    H.div [ HA.class "container" ]
        [ H.div []
            [ heading
            , form model
            ]
        , H.div []
            [ exampleWarning model
            , plot model
            ]
        ]


exampleWarningText : String
exampleWarningText =
    "This is just an example plot, paste your own URL and cookie."


exampleWarning : Model -> Html Msg
exampleWarning model =
    -- TODO bootstrap warning box
    if Example.shouldShow model then
        H.div
            [ HA.class "alert alert-info"
            , HA.attribute "role" "alert"
            ]
            [ H.text exampleWarningText ]
    else
        H.text ""


plotButton : Plot -> Plot -> Html Msg
plotButton plot currentlySelectedPlot =
    let
        isActive =
            plot == currentlySelectedPlot
    in
        H.label
            [ HA.classList
                [ ( "btn", True )
                , ( "btn-secondary", True )
                , ( "active", isActive )
                ]
            ]
            [ H.input
                [ HA.type_ "radio"
                , HA.name "plot-type"
                , HA.attribute "autocomplete" "off"
                , HA.checked isActive
                , HE.onClick (ShowPlot plot)
                ]
                []
            , H.text (plotLabel plot)
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
    H.h1
        [ HA.class "my-4" ]
        [ H.text "AoC private leaderboard viewer" ]


form : Model -> Html Msg
form model =
    H.div []
        [ urlInput model
        , cookieInput model
        , fetchButton model
        , warning
        , jsonInput model
        , radioButtons model
        ]


jsonInput : Model -> Html Msg
jsonInput model =
    H.div
        [ HA.class "form-group row" ]
        [ H.label [ HA.class "col-lg-3 col-form-label" ]
            [ H.text "JSON override:"
            ]
        , H.div [ HA.class "col-lg-9" ]
            [ H.input
                [ HA.placeholder Example.json
                -- , HA.value model.url
                , HA.class "form-control"
                , HE.onInput SetJson
                ]
                []
            ]
        ]


urlInput : Model -> Html Msg
urlInput model =
    H.div
        [ HA.class "form-group row" ]
        [ H.label [ HA.class "col-lg-3 col-form-label" ]
            [ H.text "Leaderboard JSON URL:"
            ]
        , H.div [ HA.class "col-lg-9" ]
            [ H.input
                [ HA.placeholder Example.url
                , HA.value model.url
                , HA.class "form-control"
                , HE.onInput SetUrl
                ]
                []
            ]
        ]


cookieInput : Model -> Html Msg
cookieInput model =
    H.div
        [ HA.class "form-group row" ]
        [ H.label [ HA.class "col-lg-3 col-form-label" ]
            [ H.text "Session cookie "
            , H.a
                [ HA.target "_blank"
                , HA.href "https://i.imgur.com/75BC9zU.png"
                ]
                [ H.text "(what?!)" ]
            , H.text ":"
            ]
        , H.div [ HA.class "col-lg-9" ]
            [ H.input
                [ HA.placeholder Example.cookie
                , HA.value model.cookie
                , HA.class "form-control"
                , HE.onInput SetCookie
                ]
                []
            ]
        ]


fetchButton : Model -> Html Msg
fetchButton model =
    H.div [ HA.class "form-group row" ]
        [ H.div [ HA.class "col-lg-9" ]
            [ H.button
                [ HE.onClick (Fetch model.url model.cookie)
                , HA.disabled (model.data == Loading)
                , HA.class "btn btn-primary"
                , HA.type_ "submit"
                ]
                [ H.text "Fetch! "
                , case model.data of
                    Success _ ->
                        if not (Example.shouldShow model) then
                            H.span [ HA.class "badge badge-light" ]
                                [ H.text <|
                                    "Last fetch at "
                                        ++ (model.timeOfFetch
                                                |> Date.fromTime
                                                |> Date.Extra.toFormattedString "yyyy/MM/dd', 'HH:mm:ss"
                                           )
                                ]
                        else
                            H.text ""

                    _ ->
                        H.text ""
                ]
            ]
        ]


warning : Html Msg
warning =
    H.div
        [ HA.class "alert alert-warning"
        , HA.attribute "role" "alert"
        ]
        [ H.text "WARNING: clicking the \"Fetch!\" button sends your session cookie to my CORS proxy. I promise not to use it in any way, but... yeah, not ideal."
        ]


radioButtons : Model -> Html Msg
radioButtons model =
    H.div [ HA.class "form-group row" ]
        [ H.label
            [ HA.class "col-lg-3 col-form-label" ]
            [ H.text "Show plot:" ]
        , H.div [ HA.class "col-lg-9" ]
            [ H.div
                [ HA.class "btn-group"
                , HA.attribute "data-toggle" "buttons"
                , HA.attribute "role" "group"
                , HA.attribute "aria-label" "Show plot"
                ]
                [ plotButton OneForEachMember model.plot
                , plotButton AllInOne model.plot
                ]
            ]
        ]

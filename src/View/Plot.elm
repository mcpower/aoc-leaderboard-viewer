module View.Plot exposing (plot)

import Html as H exposing (Html)
import Html.Attributes as HA
import View.Plot.Type.AllInOne as View
import View.Plot.Type.OneForEachMember as View
import Types exposing (..)
import Example
import RemoteData exposing (RemoteData(..))
import Http


plot : Model -> Html Msg
plot model =
    H.div [ HA.class "plots" ]
        (case model.data of
            NotAsked ->
                if Example.shouldShow model then
                    plotView
                        { model | data = Success Example.data }
                        Example.data
                else
                    [ H.text "" ]

            Loading ->
                [ viewLoading ]

            Failure err ->
                [ viewFailure err ]

            Success realData ->
                plotView
                    model
                    realData
        )


plotView : Model -> Data -> List (Html Msg)
plotView model data =
    case model.plot of
        AllInOne ->
            View.allInOne model data

        OneForEachMember ->
            View.oneForEachMember model data


viewLoading : Html Msg
viewLoading =
    H.text "Loading from the AoC site..."


viewFailure : Http.Error -> Html Msg
viewFailure err =
    H.text <| "Error: " ++ toString err

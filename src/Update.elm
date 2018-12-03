port module Update exposing (init, update, subscriptions)

import Dict
import Http
import Json exposing (dataDecoder)
import Json.Decode exposing (decodeString)
import RemoteData exposing (RemoteData(..))
import View.Plot as Plot
import Task
import Time
import Types exposing (..)


init : Flags -> ( Model, Cmd Msg )
init { currentTime, snapshot } =
    ( snapshot
        |> Maybe.andThen
            (\{ url, cookie, plot } ->
                plot
                    |> Plot.fromString
                    |> Result.toMaybe
                    |> Maybe.map
                        (\plot ->
                            { url = url
                            , cookie = cookie
                            , data = NotAsked
                            , timeOfFetch = currentTime
                            , hover = Nothing
                            , plot = plot
                            }
                        )
            )
        |> Maybe.withDefault
            { url = ""
            , cookie = ""
            , data = NotAsked
            , timeOfFetch = currentTime
            , hover = Nothing
            , plot = OneForEachMember
            }
    , Cmd.none
    )


port saveSnapshot : Snapshot -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetUrl url ->
            let
                newModel =
                    { model | url = url }
            in
                ( newModel
                , saveSnapshot
                    { url = url
                    , cookie = model.cookie
                    , plot = Plot.toString model.plot
                    }
                )

        SetCookie cookie ->
            let
                newModel =
                    { model | cookie = cookie }
            in
                ( newModel
                , saveSnapshot
                    { url = model.url
                    , cookie = cookie
                    , plot = Plot.toString model.plot
                    }
                )

        Fetch url cookie ->
            ( { model | data = Loading }
            , Cmd.batch
                [ getCurrentTime
                , getData model.url model.cookie
                ]
            )

        SetJson json ->
            let
                newData =
                    case decodeString dataDecoder json of
                        Ok data -> Success data
                        Err err -> Failure (Http.BadPayload err
                            { url = "localjson"
                            , status =
                                { code = 400
                                , message= ""
                                }
                            , headers = Dict.empty
                            , body = json
                            })
            in
            ( { model | data = newData }
            , getCurrentTime
            )
        
        FetchResult data ->
            ( { model | data = data }
            , Cmd.none
            )

        CurrentTime time ->
            ( { model | timeOfFetch = time }
            , Cmd.none
            )

        Hover hover ->
            ( { model | hover = hover }
            , Cmd.none
            )

        ShowPlot plot ->
            let
                newModel =
                    { model | plot = plot }
            in
                ( newModel
                , saveSnapshot
                    { url = model.url
                    , cookie = model.cookie
                    , plot = Plot.toString plot
                    }
                )


getCurrentTime : Cmd Msg
getCurrentTime =
    Time.now
        |> Task.perform CurrentTime


getData : String -> String -> Cmd Msg
getData url cookie =
    Http.get (proxyUrl url cookie) dataDecoder
        |> RemoteData.sendRequest
        |> Cmd.map FetchResult


proxyUrl : String -> String -> String
proxyUrl url cookie =
    --"http://localhost:5000/"
    "https://aoc-leaderboard-json-proxy.herokuapp.com/"
        ++ ("?url=" ++ url)
        ++ ("&cookie=" ++ cookie)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

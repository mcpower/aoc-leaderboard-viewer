port module Update exposing (init, update, subscriptions)

import Http
import Json exposing (dataDecoder)
import RemoteData exposing (RemoteData(..))
import Task
import Time
import Types exposing (..)


init : Flags -> ( Model, Cmd Msg )
init { currentTime, snapshot } =
    ( snapshot
        |> Maybe.map
            (\{ url, cookie } ->
                { url = url
                , cookie = cookie
                , data = NotAsked
                , timeOfFetch = currentTime
                , hover = Nothing
                }
            )
        |> Maybe.withDefault
            { url = ""
            , cookie = ""
            , data = NotAsked
            , timeOfFetch = currentTime
            , hover = Nothing
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
                    }
                )

        Fetch url cookie ->
            ( { model | data = Loading }
            , Cmd.batch
                [ getCurrentTime
                , getData model.url model.cookie
                ]
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

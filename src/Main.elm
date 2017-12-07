module Main exposing (main)

import Html
import Update exposing (..)
import Types exposing (..)
import View exposing (..)


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

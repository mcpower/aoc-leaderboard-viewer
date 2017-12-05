module Main exposing (main)

import Html
import Update exposing (..)
import Types exposing (..)
import View exposing (..)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }

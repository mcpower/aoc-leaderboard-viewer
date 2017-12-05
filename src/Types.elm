module Types exposing (..)

import Plot as P exposing (Point)
import Date exposing (Date)


type alias Model =
    { json : String
    , data : Result String Data
    , hover : Maybe Point
    }


type Msg
    = SetJson String
    | Hover (Maybe Point)


type alias Data =
    List Member


type alias Member =
    { name : String
    , localScore : Int
    , globalScore : Int
    , stars : Int
    , completionTimes : List ( Day, Star, Date )
    }


type alias Day =
    Int


type alias Star =
    Int

module DrumMachine exposing (..)

-- where

import Html.App
import Model exposing (model, Model)
import Update exposing (Msg)
import View exposing (view)
import Subscriptions exposing (subscriptions)
import Ports


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let
    ( nextModel, nextCmd ) =
      Update.update msg model
  in
    ( nextModel
    , Cmd.batch
        [ Ports.logExternal msg
        , nextCmd
        ]
    )


main : Program Never
main =
  Html.App.program
    { init = ( model, Cmd.none )
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

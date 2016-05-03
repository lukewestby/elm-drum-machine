port module Ports exposing (..)

import Array exposing (Array)
import Json.Encode as Encode
import Model exposing (Model, encodeTrack, Track)


port playSoundOut : Encode.Value -> Cmd msg


port persistModelOut : Encode.Value -> Cmd msg


port logExternalOut : String -> Cmd msg


playSound : (Int, Array Track) -> Cmd msg
playSound (currentSlotIndex, tracks) =
  let
    value =
      Encode.object
        [ ( "currentSlotIndex", Encode.int currentSlotIndex )
        , ( "tracks", Encode.list <| List.map encodeTrack <| Array.toList tracks)
        ]
  in
    playSoundOut value


persistModel : Model -> Cmd msg
persistModel model =
  let
    value =
      Model.encodeModel model
  in
    persistModelOut value


logExternal : a -> Cmd msg
logExternal value =
  logExternalOut (toString value)

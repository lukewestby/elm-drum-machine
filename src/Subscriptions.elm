port module Subscriptions exposing (..)

-- where

import Model exposing (Model)
import Update exposing (Msg(..))
import Time exposing (Time)


port loadProgressEvents : (Float -> msg) -> Sub msg

port loadSuccessEvent : ({} -> msg) -> Sub msg

port loadFailureEvent : ({} -> msg) -> Sub msg


clock : Model -> Sub Msg
clock model =
  if model.isPlaying then
    Time.every (computeTempoInterval model.tempo) (always Advance)
  else
    Sub.none


loadProgress : Model -> Sub Msg
loadProgress model =
  if model.loadState.loading then
    loadProgressEvents LoadProgress
  else
    Sub.none


loadSuccess : Model -> Sub Msg
loadSuccess model =
  if model.loadState.loading then
    loadSuccessEvent (always LoadSuccess)
  else
    Sub.none


loadFailure : Model -> Sub Msg
loadFailure model =
  if model.loadState.loading then
    loadFailureEvent (always LoadFailure)
  else
    Sub.none


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ clock model
    , loadProgress model
    , loadSuccess model
    , loadFailure model
    ]


computeTempoInterval : Int -> Float
computeTempoInterval beatsPerMinute =
  let
    quartersPerMilli =
      (toFloat beatsPerMinute) / 60000

    sixteenthsPerMilli =
      quartersPerMilli * 4

    millisPerSixteenth =
      1 / sixteenthsPerMilli
  in
    millisPerSixteenth

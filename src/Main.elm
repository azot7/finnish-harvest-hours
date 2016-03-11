module Main (..) where

import Model exposing (..)
import Update exposing (Action, update)
import View exposing (view)
import StartApp
import Signal exposing (Signal, Mailbox, Address, send)
import Html exposing (..)
import Task
import Effects exposing (Effects, Never)
import Time exposing (Time)
import Date exposing (fromTime)


port currentTime : Time
app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


init : ( Model, Effects Action )
init =
  ( initialModel
  , Effects.batch
      [ Update.getUser
      , Update.getEntries
      , Update.getHolidays
      ]
  )


initialModel : Model
initialModel =
  let
    today =
      Date.fromTime currentTime
  in
    { httpError = Ok ()
    , today = today
    , currentMonth = Date.month today
    , entries = []
    , totalHours = 0
    , user = { firstName = "", lastName = "" }
    , holidays = []
    }

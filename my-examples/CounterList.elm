module CounterList where

import Counter
import Html
import Html.Events exposing (onClick)

-- Model

type alias Model = { counters : List (ID, Counter.Model),
                     nextId : ID }
type alias ID = Int

init : Model
init = { counters = [],
         nextId = 0 }

-- Update
type Action = Insert | Remove | Modify ID Counter.Action

update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      let newCounter = ( model.nextId, Counter.init 0 )
          newCounterList = model.counters ++ [ newCounter ]
      in
        { model | counters = newCounterList, nextId = nextId + 1}
    Remove ->
    Modify id act ->

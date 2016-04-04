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
        { model | counters = newCounterList, nextId = model.nextId + 1}
    Remove ->
      { model | counters = List.drop 1 model.counters }
    Modify id act ->
      let updateCounter (counterId, counterModel) =
        if counterId == id then
          (counterId, Counter.update act counterModel)
        else
          (counterId, counterModel)
      in
        { model | counters = List.map updateCounter model.counters }

-- View
view : Signal.Address Action -> Model -> Html.Html
view address model =
  let counters = List.map (viewCounter address) model.counters
      remove = Html.button [ onClick address Remove ] [ Html.text "Remove" ]
      add = Html.button [ onClick address Insert ] [ Html.text "Add" ]
  in
    Html.div [] ([remove, add] ++ counters)

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html.Html
viewCounter address (id, model) =
  Counter.view (Signal.forwardTo address (Modify id)) model


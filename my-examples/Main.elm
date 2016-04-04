import CounterList exposing (init, update, view)
import StartApp.Simple exposing (start)

main = start { model = init,
               update = CounterList.update,
               view = CounterList.view }
import Counter
import StartApp.Simple exposing (start)

main = start { model = { count = 0 }, update = Counter.update, view = Counter.view }
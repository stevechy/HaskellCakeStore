import qualified Network.Wai.Handler.Warp as Warp
import qualified Web.HaskellCakeStoreWeb as Web

port = 8080

main :: IO ()
main = do
  print $ "Running webserver on port " ++ (show port)
  Warp.run port Web.app









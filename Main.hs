import qualified Network.Wai.Handler.Warp as Warp
import qualified Web.HaskellCakeStoreWeb as Web
import qualified Configuration.Util
import System.Environment

port = 8080

main :: IO ()
main = do
  args <- getArgs
  let configFile = head args
  print $ "Reading config file " ++ configFile
  maybeConfiguration <- Configuration.Util.readConfiguration configFile
  print $ "Running webserver on port " ++ (show port)
  case maybeConfiguration of 
    Just configuration -> do
      app <- Web.buildApp configuration
      Warp.run port app
      --Warp.run port Web.simpleApp
    Nothing -> do
      print "Invalid configuration file"
      return ()
      









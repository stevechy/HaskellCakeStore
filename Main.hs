import qualified Network.Wai.Handler.Warp as Warp
import qualified Web.HaskellCakeStoreWeb as Web

port = 8080

main :: IO ()
main = Warp.run port Web.app









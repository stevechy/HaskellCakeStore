module Web.HaskellCakeStoreWeb
( app)
where 


import Network.Wai as Wai
import qualified Web.Handler.HomePage as HomePage


app :: Wai.Application
app request = HomePage.handle request




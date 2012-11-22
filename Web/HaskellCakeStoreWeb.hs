module Web.HaskellCakeStoreWeb
( app )
where 


import Network.Wai as Wai
import qualified Web.Handler.HomePage as HomePage
import Web.HandlerMonad as HandlerMonad


app :: Wai.Application
--app request = HomePage.handle request
app request = HandlerMonad.runHandlerMonad HomePage.handleMonad




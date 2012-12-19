
module Web.Handler.HomePage
(handleMonad)
where

import qualified Web.View.HomePage as HomePageView
import qualified Service.Users
import qualified Web.WebHandler

handleMonad :: Web.WebHandler.HandlerMonad ()
handleMonad = do
      user <- Web.WebHandler.callService Service.Users.getUser
      Web.WebHandler.renderView $ HomePageView.render $ user
      return ()





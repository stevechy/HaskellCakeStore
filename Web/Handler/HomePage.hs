{-# LANGUAGE OverloadedStrings #-}

module Web.Handler.HomePage
(handleMonad)
where

import qualified Web.WebHelper as WebHelper
import qualified Web.View.HomePage as HomePageView
import qualified Service.Users as Users
import qualified Web.WebHandler as WebHandler
import Data.ByteString.Lazy.UTF8
import qualified Service.Users


handleMonad :: WebHandler.HandlerMonad ()
handleMonad = do
      user <- WebHandler.callService Service.Users.getUser
      WebHandler.renderView $ HomePageView.render $ user
      return ()





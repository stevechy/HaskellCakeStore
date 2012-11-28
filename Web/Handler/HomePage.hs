{-# LANGUAGE OverloadedStrings #-}

module Web.Handler.HomePage
(handleMonad)
where

import qualified Web.WebHelper as WebHelper
import qualified Web.View.HomePage as HomePageView
import qualified Service.Users as Users
import qualified Web.HandlerMonad as HandlerMonad
import Data.ByteString.Lazy.UTF8
import qualified Service.Users


handleMonad :: HandlerMonad.HandlerMonad ()
handleMonad = do
      user <- HandlerMonad.callService Service.Users.getUser
      HandlerMonad.renderView $ HomePageView.render $ user
      return ()





{-# LANGUAGE OverloadedStrings #-}

module Web.Handler.HomePage
(handle, handleMonad)
where


import qualified Web.WebHelper as WebHelper
import qualified Web.View.HomePage as HomePageView
import qualified Service.Users as Users
import qualified Web.HandlerMonad as HandlerMonad
import Data.ByteString.Lazy.UTF8

handle request = WebHelper.plainResponse $ WebHelper.toBuilder $ HomePageView.render $ Users.getUser


handleMonad :: HandlerMonad.HandlerMonad ()
handleMonad = do
      user <- HandlerMonad.getUser 
      HandlerMonad.renderView $ WebHelper.toBuilder $ HomePageView.render $ user
      return ()





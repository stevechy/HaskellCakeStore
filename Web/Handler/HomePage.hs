module Web.Handler.HomePage
(handle)
where

{-# LANGUAGE OverloadedStrings #-}

import qualified Web.WebHelper as WebHelper
import qualified Web.View.HomePage as HomePageView
import qualified Service.Users as Users

handle request = WebHelper.plainResponse $ WebHelper.toBuilder $ HomePageView.render $ Users.getUser






module Web.Handler.HomePage
(handle)
where

{-# LANGUAGE OverloadedStrings #-}

import qualified Web.WebHelper as WebHelper
import Blaze.ByteString.Builder as BlazeBuilder
import Data.ByteString.Lazy.UTF8
import Data.Monoid
import qualified Service.Users as Users

handle request = WebHelper.plainResponse builder

builder :: BlazeBuilder.Builder
builder = mconcat (map (fromLazyByteString . fromString) content)

content = ["<html>","<body>","Hi", Users.getUser ,"</body>","</html>"] 



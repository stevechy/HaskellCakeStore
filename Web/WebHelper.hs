{-# LANGUAGE OverloadedStrings #-}

module Web.WebHelper
(plainResponse, toBuilder)
where

import Network.Wai as Wai
import Control.Monad.IO.Class (liftIO)
import qualified Data.Conduit as Conduit
import qualified Network.HTTP.Types.Status as HTTPTypes
import qualified Network.HTTP.Types.Header
import Blaze.ByteString.Builder as BlazeBuilder
import Data.Monoid
import Data.ByteString.Lazy.UTF8

plainResponse :: BlazeBuilder.Builder ->  Conduit.ResourceT IO Wai.Response
plainResponse builder = liftIO $ return $ Wai.ResponseBuilder HTTPTypes.ok200 [(Network.HTTP.Types.Header.hContentType, "text/html" )] builder

toBuilder :: [String] -> BlazeBuilder.Builder
toBuilder content = mconcat (map (fromLazyByteString . fromString) content)


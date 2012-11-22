module Web.WebHelper
(plainResponse)
where

import Network.Wai as Wai
import Control.Monad.IO.Class (liftIO)
import qualified Data.Conduit as Conduit
import qualified Network.HTTP.Types.Status as HTTPTypes
import Blaze.ByteString.Builder as BlazeBuilder
import Data.Monoid

plainResponse :: BlazeBuilder.Builder ->  Conduit.ResourceT IO Wai.Response
plainResponse builder = liftIO $ return $ Wai.ResponseBuilder HTTPTypes.ok200 [] builder
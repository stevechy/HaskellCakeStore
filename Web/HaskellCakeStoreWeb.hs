module Web.HaskellCakeStoreWeb
( app)
where 


import Network.Wai as Wai
import Web.WebHelper as WebHelper
import Blaze.ByteString.Builder as BlazeBuilder
import Data.Monoid

app :: Wai.Application
app request = WebHelper.plainResponse builder 

builder :: BlazeBuilder.Builder
builder = mempty



{-# LANGUAGE GADTs #-}

module Web.WebHandler
(renderView, 
HandlerMonad,
callService,
setupHandlerMonad,
handleMonadWithConfiguration,
WebConfiguration)
where

import Control.Monad.Operational

import Network.Wai as Wai
import Control.Monad.IO.Class (liftIO)
import qualified Data.Conduit as Conduit
import Blaze.ByteString.Builder as BlazeBuilder
import Data.Monoid
import Web.WebHelper as WebHelper
import qualified Service.ServiceHandler as ServiceHandler
import qualified Configuration.Types

handleMonadWithConfiguration :: WebConfiguration -> HandlerMonad a -> Conduit.ResourceT IO Wai.Response
handleMonadWithConfiguration configuration handlerMonad = runHandlerMonadWithConfigurationAndState configuration mempty handlerMonad

data WebConfiguration = WebConfiguration { serviceConfiguration :: ServiceHandler.ServiceConfiguration}

data HandlerInstruction a
   where RenderView :: BlazeBuilder.Builder -> HandlerInstruction ()
         CallService :: ServiceHandler.ServiceCall a -> HandlerInstruction a
         
renderView :: Builder -> ProgramT HandlerInstruction m ()
renderView content = singleton $ RenderView content

callService :: ServiceHandler.ServiceCall a -> ProgramT HandlerInstruction m a
callService call = singleton $ CallService $ call

type HandlerMonad a = Program HandlerInstruction a

runHandlerMonadWithConfigurationAndState :: WebConfiguration -> BlazeBuilder.Builder -> HandlerMonad a -> Conduit.ResourceT IO Wai.Response
runHandlerMonadWithConfigurationAndState configuration state = eval . view
		where 
		eval :: ProgramView (HandlerInstruction) a -> Conduit.ResourceT IO Wai.Response
		eval (Return _) = plainResponse $ state
		eval (RenderView s :>>= k) = runHandlerMonadWithConfigurationAndState configuration (mappend state s) $ k $ () 
                eval (CallService call :>>= k) = do
		     callResult <- liftIO $ runServiceCall configuration call
		     runHandlerMonadWithConfigurationAndState configuration state $ k $ callResult

setupHandlerMonad :: Configuration.Types.Configuration -> ServiceHandler.ServiceConfiguration -> IO WebConfiguration
setupHandlerMonad configuration serviceConfig = do 
  return WebConfiguration { serviceConfiguration = serviceConfig }

runServiceCall :: WebConfiguration -> ServiceHandler.ServiceCall a -> IO a
runServiceCall webConfiguration call = ServiceHandler.handleWithConfiguration (serviceConfiguration webConfiguration) call



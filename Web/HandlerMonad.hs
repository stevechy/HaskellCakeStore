{-# LANGUAGE GADTs #-}

module Web.HandlerMonad
(renderView, 
getUser,
HandlerMonad,
runHandlerMonad,
callService)
where

import Control.Monad.Operational

import Network.Wai as Wai
import Control.Monad.IO.Class (liftIO)
import qualified Data.Conduit as Conduit
import qualified Network.HTTP.Types.Status as HTTPTypes
import Blaze.ByteString.Builder as BlazeBuilder
import Data.Monoid
import Data.ByteString.Lazy.UTF8
import Web.WebHelper as WebHelper
import qualified Service.ServiceHandler as ServiceHandler

data HandlerInstruction a
   where RenderView :: BlazeBuilder.Builder -> HandlerInstruction ()
         GetUser :: HandlerInstruction String
         CallService :: ServiceHandler.ServiceCall a -> HandlerInstruction a

renderView content = singleton $ RenderView content
getUser = singleton GetUser
callService call = singleton $ CallService $ call

type HandlerMonad a = Program HandlerInstruction a

runHandlerMonad :: HandlerMonad a -> Conduit.ResourceT IO Wai.Response
runHandlerMonad = runHandlerMonadWithState mempty

runHandlerMonadWithState :: BlazeBuilder.Builder -> HandlerMonad a -> Conduit.ResourceT IO Wai.Response
runHandlerMonadWithState state = eval . view
		where 
		eval :: ProgramView (HandlerInstruction) a -> Conduit.ResourceT IO Wai.Response
		eval (Return x) = plainResponse $ state
		eval (RenderView s :>>= k) = runHandlerMonadWithState (mappend state s) $ k $ () 
		eval (GetUser :>>= k) = runHandlerMonadWithState state $ k $ "User"
                eval (CallService call :>>= k) = do
		     callResult <- liftIO $ runServiceCall call
		     runHandlerMonadWithState state $ k $ callResult


runServiceCall :: ServiceHandler.ServiceCall a -> IO a
runServiceCall call = ServiceHandler.handle call





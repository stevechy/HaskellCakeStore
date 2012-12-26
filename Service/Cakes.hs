{-# LANGUAGE NoMonomorphismRestriction #-}

module Service.Cakes
(getCakes,
 addCake)
where
  
import qualified Data.Cakes
import Service.ServiceHandler
import qualified Model.Cake
  
getCakes :: ServiceCall [Model.Cake.Cake]  
getCakes = ServiceCall {
  Service.ServiceHandler.name = "getCakes",
  Service.ServiceHandler.execution = do
    dataCall Data.Cakes.getCakes
  }

addCake :: String -> ServiceCall ()  
addCake name = ServiceCall {
  Service.ServiceHandler.name = "addCake",
  Service.ServiceHandler.execution = do
    dataCall $ Data.Cakes.addCake name
    return ()
  }
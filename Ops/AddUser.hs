
import qualified Configuration.Util
import qualified Data.DataHandler
import qualified Service.ServiceHandler
import qualified Service.Users

main :: IO()  
main = do
    Just configuration <- Configuration.Util.readConfiguration "Configuration.yaml"
    configurationTVar <- Data.DataHandler.setupDataMonad configuration
    serviceConfiguration <- Service.ServiceHandler.setupServiceMonad configuration configurationTVar
    Service.ServiceHandler.handleWithConfiguration serviceConfiguration $ Service.Users.addUser "Steve"
    return ()
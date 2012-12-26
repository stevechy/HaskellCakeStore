
import Database.HDBC 
import Database.HDBC.Sqlite3
import System.Environment
import qualified Configuration.Util as ConfigurationUtil
import qualified Configuration.Types as ConfigurationTypes

main :: IO ()
main = do
     args <- getArgs
     let configFile = head args
     print $ "Reading config file " ++ configFile
     maybeConfiguration <- ConfigurationUtil.readConfiguration configFile
     case maybeConfiguration of
     	  Just configuration -> runConfiguration configuration
          Nothing -> return ()

runConfiguration configuration = do
     conn <- connectSqlite3 $ ConfigurationTypes.databaseFile $ configuration
     tables <- getTables conn
     print tables
     withTransaction conn $ createTest tables
     disconnect conn

createTest tables conn = do    
    if not $ elem "users" tables
         then do
                run conn "CREATE TABLE users (id INTEGER NOT NULL PRIMARY KEY, name VARCHAR(256))" []
                run conn "INSERT INTO users (name) VALUES ('DatabaseBob')" []
                query <- quickQuery' conn "SELECT * from users where id < 2" []
                print query
                return ()
         else return ()
    if not $ elem "cakes" tables
         then do
                run conn "CREATE TABLE cakes (id INTEGER NOT NULL PRIMARY KEY, name VARCHAR(256))" []               
                return ()
         else return ()

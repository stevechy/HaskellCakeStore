
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

createTest tables conn =     
    if not $ elem "test" tables
         then do
                run conn "CREATE TABLE test (id INTEGER NOT NULL, desc VARCHAR(80))" []
                run conn "INSERT INTO test (id) VALUES (0)" []
                query <- quickQuery' conn "SELECT * from test where id < 2" []
                print query
                return ()
         else return ()

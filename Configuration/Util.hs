module Configuration.Util
where

import Data.Yaml
import Configuration.Types

readConfiguration :: FilePath -> IO (Maybe Configuration)
readConfiguration filePath = decodeFile filePath


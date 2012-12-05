import Test.HUnit

import qualified Tests.DataTest
import qualified Tests.ServiceTest
import qualified Tests.WebTest

tests = TestList [TestLabel "data tests" Tests.DataTest.tests, 
                  TestLabel "service tests" Tests.ServiceTest.tests,
                  TestLabel "web tests" Tests.WebTest.tests]

main = runTestTT tests



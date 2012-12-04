import Test.HUnit

import qualified Tests.DataTest
import qualified Tests.ServiceTest

tests = TestList [TestLabel "data tests" Tests.DataTest.tests, TestLabel "service tests" Tests.ServiceTest.tests]

main = runTestTT tests



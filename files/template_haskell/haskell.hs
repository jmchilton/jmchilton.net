-- Pattern matching
fact :: Int -> Int
fact 0 = 1
fact n = n * (fact (n - 1))



-- Lists
sumList :: [Int] -> Int
sumList [] = 0
sumList (x : xs) = x + (sumList xs)




-- Polymorphism
listSelect :: Int -> [a] -> a
listSelect 0 (x : xs) = x
listSelect n (x : xs) = listSelect (n - 1) xs





-- Lazy evaluation, a little example
ones = 1 : ones

one = listSelect 65 ones







-- New Data Types and Pattern Matching
data Point = Pt Rational Rational

euclidDist (Pt x1 y1) (Pt x2 y2) =
  let dx = (x1 - x2)
      dy = (y1 - y2)
  in
    sqrt( dx * dx + dy * dy )

pointX (Pt x _) = x

-- Commonly used builtin data type
data Maybe a = Nothing | Just a







-- List comprensions, alot like python. 
-- [1,2,3,4,5,6,7,8,9,10]
oneTo10 = [1..10]

-- [3,5,7]
anotherList = [2*i+1 | i <- [1..3]]











-- map, nameless procedures, and currying

sq x = x * x
l1 = map sq oneTo10 

-- Or via nameless procedure
l2 = map (\x -> (2 * x)) oneTo10

-- Or via currying
l3 = map (* 2) oneTo10

-- doubleList takes in a list and doubles each element
doubleList = map (* 2)

l4 = doubleList oneTo10

-- l1 = l2 = l3 = l4 = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]



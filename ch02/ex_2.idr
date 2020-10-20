-- 2.2
palindrome : String -> Bool
palindrome str = str == reverse str

-- 2.3
palindrome2 : String -> Bool
-- palindrome2 str = toLower str == reverse (toLower str)
-- palindrome2 str = palindrome (toLower str)
-- palindrome2 = palindrome . toLower
palindrome2 str = let strL = toLower str in
                      strL == reverse strL

-- 2.4
palindrome3 : String -> Bool
palindrome3 str = if length str > 10
                  then (palindrome str)
                  else False

-- 2.5
palindrome4 : Nat -> String -> Bool
palindrome4 len str = if length str > len then (palindrome str) else False

-- 2.6
counts : String -> (Nat, Nat)
counts str = (length (words str), (length str))

-- 2.7
top_ten : Ord a => List a -> List a
top_ten xs = take 10 (reverse (sort xs))

-- 2.8
over_length : Nat -> List String -> Nat
-- over_length num xs = length (filter (\x => (length x) > num) xs)
over_length num xs = let lengths = map length xs in
                         length (filter (> num) lengths)

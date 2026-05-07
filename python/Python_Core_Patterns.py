# ============================================================
# PYTHON CORE PATTERNS
# Author: Shiva
# Created: May 5, 2026
# ============================================================
#
# 50 Questions | 5 Categories | 17 Days
#
# Category 1 — Basics          (10 questions)
# Category 2 — Loops           (10 questions)
# Category 3 — Functions       (10 questions)
# Category 4 — Comprehensions  (10 questions)
# Category 5 — OOP             (10 questions)
#
# Prep    : May 5 – May 22
# Mock    : May 23
# Apply   : May 25
# Target  : 14–18 LPA by July end
# ============================================================
# Category 1 — Basics  - (10 Questions)
# Q1.  Reverse a string
text = "Hello"
reversed_text = ""
for i in text:
    reversed_text = i + reversed_text
print(reversed_text)

#Mini Challenge 
# Problem: Take a user's full name like "Shiva Kumar" and generate a username by reversing each word individually, 
# keeping them in the same order, and making it all lowercase.
user_name = "Shiva Kumar"
words = user_name.split()
reversed_order = []
print(" ".join([word[::-1] for word in words]).lower())

# Q2.  Check palindrome (string & number)
# Q2.  Check palindrome (string & number)
text = "madam".lower()
reversed_one = text[::-1]
if reversed_one == text:
    print("palindrome")
else:
    print("Not palindrome")

num = 191
original_num = num
reversed_num = 0

while num > 0:
    digit = num % 10
    reversed_num = reversed_num * 10 + digit
    num = num // 10

if original_num == reversed_num:
    print("Palindrome")
else:
    print("Not Palindrome")

# Problem: Given a list of words, print only the ones that are palindromes.
# Input:  ["madam", "hello", "racecar", "world", "level", "python"]
# Output: ["madam", "racecar", "level"]

Input = ["madam", "hello", "racecar", "world", "level", "python"]
result = [word for word in Input if word == word[::-1]]
print(result)

# Q3.  Swap two variables (without temp)
a = 10
b = 3
a, b = b,a
print(a,b)

# Mini Challenge for Q3
# Problem: Given a list of 5 numbers, swap the first and last elements, and swap the second and fourth elements. Middle stays.
# Input:  [1, 2, 3, 4, 5]
# Output: [5, 4, 3, 2, 1]

nums = [1,2,3,4,5]
nums[0], nums[4] = nums[4], nums[0]
nums[1], nums[3] = nums[3], nums[1]
print(nums)

# Q4: Count Vowels in a String
text = "Shiva".lower()
vowels = "aeiou"
count = 0
for i in text:
    if i in vowels:
        count += 1
print(count)

# Mini Challenge for Q4
# Problem: Given a sentence, find which vowel appears the most and how many times.
# Input:  "banana is a amazing fruit"
# Output: "a appears 7 times"

sentence = "banana is a amazing fruit".lower()
vowels = "aeiou"
freq = {}
for i in sentence:
    if i in vowels:
        freq[i] = freq.get(i,0) + 1
print(freq)

max_vowel = ""
max_count = 0
for vowel, count in freq.items():
    if count > max_count:
        max_count = count
        max_vowel = vowel

print(f"{max_vowel} appears {max_count} times")

# Q5: Find Length of String (Without len())

text = "shiva kumar"
count = 0
for i in text:
    count += 1
print(count)

# Problem: Given two strings, find which one is longer without using len(), and print by how many characters.
# Input:  "python", "java"
# Output: "python is longer by 2 characters"

str1 = "python"
str2 = "java"
count1 = 0
count2 = 0
for i in str1:
    count1 += 1
for j in str2:
    count2 += 1
if count1 > count2:
    print(f"{str1} is longer by {count1 - count2} characters")
else:
    print(f"{str2} is longer by {count2 - count1} characters")


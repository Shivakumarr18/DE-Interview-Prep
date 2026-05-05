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
def reverse_string(text):
    reversed_str = ""
    for char in text:
        reversed_str = char + reversed_str
    return reversed_str

# Q2.  Check palindrome (string & number)
def is_palindrome(data):
    s = str(data)
    return s == s[::-1]

# Q3.  Swap two variables (without temp)
a = 10
b = 20

a, b = b, a

print(f"a: {a}, b: {b}") 

# Q4.  Count vowels in a string
def count_vowels(text):
    vowels = "aeiouAEIOU"
    count = 0
    for char in text:
        if char in vowels:
            count += 1
    return count

# Q5.  Find length of string (without len())
def manual_length(text):
    count = 0
    for i in text:
        count += 1
    return count




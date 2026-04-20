print("Practice Started")
# Problem 1: Reverse a string without using [::-1] or reversed(). Write the logic manually.
def manual_reverse(text):
    reversed_str = ""
    # Start from len - 1, go down to -1, in steps of -1
    for i in range(len(text) - 1, -1, -1):
        reversed_str += text[i]
    return reversed_str

# Problem 2: Given a string, return a dictionary with the count of each character.
# Ignore spaces. Case-insensitive.
# Example: "Data Engineer" → {'d': 1, 'a': 2, 't': 1, 'e': 3, 'n': 2, 'g': 1, 'i': 1, 'r': 1}
def char_count(text):
    counts = {}
    # Standardize to lowercase and remove spaces
    clean_text = text.lower().replace(" ", "")
    
    for char in clean_text:
        if char in counts:
            counts[char] += 1
        else:
            counts[char] = 1
    return counts

# Problem 3: Check if two strings are anagrams of each other. Don't use sorted() — do it via character counting.
# Example: "listen", "silent" → True
def is_anagram(str1, str2):
    if len(str1) != len(str2):
        return False
    
    # Use our character counting logic
    def get_counts(s):
        d = {}
        for c in s.lower():
            d[c] = d.get(c, 0) + 1
        return d
    
    return get_counts(str1) == get_counts(str2)

# Problem 4: Given a list of integers, remove duplicates while preserving original order. Don't use set() directly as the final output.
# Example: [3, 1, 4, 1, 5, 9, 2, 6, 5, 3] → [3, 1, 4, 5, 9, 2, 6]
def unique_ordered(nums):
    seen = set()
    result = []
    for x in nums:
        if x not in seen:
            result.append(x)
            seen.add(x) # Marking it as seen for next time
    return result
# Problem 5: Given a list of integers, find the second largest number. Handle the case where all elements are identical.
# Example: [10, 20, 4, 45, 99, 99] → 45
def find_second_largest(nums):
    if len(nums) < 2:
        return None
    
    first = second = float('-inf') # Initialize with negative infinity
    
    for x in nums:
        if x > first:
            second = first # The old largest becomes the second largest
            first = x      # The current number is the new largest
        elif x > second and x != first:
            second = x     # Update second largest if it's smaller than x but not equal to first
            
    return second if second != float('-inf') else None
# Problem 6: Given a string, find the first non-repeating character. Return None if all characters repeat.
# Example: "aabbcdd" → 'c'
def first_unique_char(text):
    counts = {}
    for char in text:
        counts[char] = counts.get(char, 0) + 1
    
    for char in text:
        if counts[char] == 1:
            return char
    return None
# Problem 7: Given two lists, return their intersection without duplicates, preserving the order from the first list.
# Example: [1, 2, 2, 3, 4] and [2, 4, 6, 4] → [2, 4]
def intersect_ordered(list1, list2):
    set2 = set(list2) # Using a set for O(1) lookup speed
    result = []
    seen_in_result = set()
    
    for item in list1:
        if item in set2 and item not in seen_in_result:
            result.append(item)
            seen_in_result.add(item)
    return result
# Problem 8: Given a list of strings, group them by length into a dictionary.
# Example: ["cat", "dog", "bird", "fish", "ant"] → 
# {3: ['cat', 'dog', 'ant'], 4: ['bird', 'fish']}
def group_by_length(words):
    groups = {}
    for word in words:
        length = len(word)
        if length not in groups:
            groups[length] = []
        groups[length].append(word)
    return groups
# Problem 9: Given a sentence, return the longest word. If there are ties, return the first one encountered.
# Example: "Data engineering is challenging" → 'challenging'
def longest_word(sentence):
    words = sentence.split()
    if not words:
        return None
    
    champion = words[0]
    for i in range(1, len(words)):
        if len(words[i]) > len(champion):
            champion = words[i]
    return champion
# Problem 10: Given a list of integers, return a new list where each element is the product of all other elements except itself. Don't use division.
# Example: [1, 2, 3, 4] → [24, 12, 8, 6]
def product_except_self(nums):
    n = len(nums)
    res = [1] * n
    
    # Left pass: res[i] contains product of all elements to the left of i
    left_product = 1
    for i in range(n):
        res[i] = left_product
        left_product *= nums[i]
        
    # Right pass: multiply existing res[i] by product of all elements to the right of i
    right_product = 1
    for i in range(n - 1, -1, -1):
        res[i] *= right_product
        right_product *= nums[i]
        
    return res
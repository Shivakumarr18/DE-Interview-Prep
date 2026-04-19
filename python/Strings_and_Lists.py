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
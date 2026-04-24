# Errors as a UI — my engineering philosophy

Most developers treat error messages as noise — cryptic strings that 
exist only to signal "something went wrong." I believe errors are a 
UI — the last thing a user sees before they form an opinion about 
the code. So I design errors like I would design a dashboard.

## Principles I follow

- **Every error answers 3 questions:** what broke, where, and what to do next.
- **No one should need to open Google** to understand a failure in my pipeline.
- **The error should contain its own fix** — the user reads two lines and moves on.
- **Specific exception types, not generic `Exception`** — so downstream code can 
  recover intelligently.
- **Context over cleverness** — include paths, values, row counts. Evidence wins.

## What I want users of my code to feel

Not frustration. Not confusion. A small sigh of relief — 
"Oh, this error actually tells me what to do."

## Why this matters

In production, the person reading the error at 3 AM is often tired, 
under pressure, and unfamiliar with the code. A good error message 
respects them. A bad one wastes their night.

This is my bar for every `raise` I write.

# The basic tools

Tools *amplify* your talent.
Expect to add tools to toolbox regularly

Palest ink better than best memory. Keep a log.

## The Power of PlainText

Base material: Knowledge (Especially in age of AI). Markdown. Make understandable to Humans AND AI
Can be structured, HTML, JSON, TAML are plaintext

Caveat book is written as "Human Readable" Understand this as human and AI readable.

Human readable data forms will outlive other forms.

Adding human readable semantic meaning to things like yaml, or json

`<Field-10> 4592345454</Field-10> vs <Social-Security-No>345-23-3432</Social-Security-No>`

### Aside unix
designed around small sharp tools each doing a thing well

When systems crash you may get minimal environment to restore it: shows value plain text.

Plain text much easier to search
### End Aside

## Shell games

Workbench: Terminal
(Claude files)

GUIs are easier for some things, but harder to automate

GUI: WYSIWYG, but its ALL you get. Limited by designers intent

## A shell of your own

Aliases, command completion

## 18 Power editing
Text is basic raw material of programming

By becoming fluent, no longer have to think about mechanics of editing

Every time you do something repetitive, think to yourself "There must be a better way". Then find it.

Work without a mouse for a day

## 19 Version Control

With a proper version control you can always go back to a specific version
Always use it, code, docs, claud files, personal notes, etc.

Branch: Little clone project

Thought exercise: Spill a cup of coffee on machine. How long get EVERYTHING back up. Code, keys, claude, homebrew, projects. Anything NOT easy, consider version controlling anc backing up on GH.

## 20 Debugging

Debugging is JUST problem solving, approach it as such WITHOUT blame. Doesnt matter who caused it, its in your name, its your problem.

"The easiest person to decieve is oneself."

Dont panic, slow is smooth. If your response is 'that's impossible' You are plainly wrong.

Avoid Myopia. Try to discover root.

You may need to interview the bug finder. 

You need to brutally test boundary conditions.

Best fix: reproducible. But not reproducible by a long convoluted series of steps. That may be necessary to GET the repro, but then REPRO IN SPEC. Often by forcing self to isolate the bug you gain insight into how to fix it.

Read the darn error message/stack trace.

Aside: for tricky bugs, keep a notes file.

### prod vs local

Sometimes it works locally, but crashes in prod. Get the full data set.
Aside: Also consider ENV issues that may not repro locally.

### Binary chop

Sort arr, look for specific val
check midpoint, if yours, use it, else go right if higher, left if lower. Repeat until found. O(log n) vs O(n)

run binary chop on interim commits

Logging over debugging in is invaluable in concurrent processes, real time systems, and event based applications

#### Rubber Ducking

Attempt to explain a cause to someone else.

Causes you to verbalize assumptions, often exposing them. 

#### Process of Elimination

Could be compiler, os, third party. Much more likely bug is in your code. (Some caveats working wiht third party integrations)

Even if with third party, you need to eliminate your code before submitting bug report

Aside: It's mentally rewarding/egotistic to assume the bug is someone else. We can do it as a first line to protect ourselves.

If you see hoof prints, think horses, not zebras.

When faced with a surprising failure, you must confront the fact one of your assumptions is wrong.

When catching a surprise, dont just fix it. Determine WHY is was not caught earlier. Are there other places susceptible to this bug?

Ask self: Is apparent problem true problem, or symptom?

## 21 Text manipulation

text manipulation languages analagous to routers in woodworking, noisy, messy, brute force

`awk` and `sed`

This book, PDF built in ruby, also code is tested, also website updated

Aside ALOT of these skill sets seem to be significantly less important in the age of AI.

## 22 Engineering Daybooks

Daybook, use paper.

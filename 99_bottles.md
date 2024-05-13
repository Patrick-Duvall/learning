# 99 bottles

1.2 Judging code
You have internal rules about code you follow

1.2.1 evaluating code based on opinion
good code: highest value for lowest cost

1.2.2 evaluating code based on facts
metrics
loc
cyclomatic complexity -> how many branches
ABC -> assignment, brances, and conditionals
  Flog


Metrics are fallible but human opinion is no more precise. Checking metrics regularly will keep you humble and improve your code.

1.23
Shameless green for now

Code that’s good enough when nothing ever changes may not be good enough when things do

2 Testing shameless green

2.1

getting to green tests quickly is often at odds with writing perfectly changeable code.

2.2 Writing the first test

A walkthrough of TDD, write the test, then make the change to make the test pass
using TDD you get a string as the first verse(most easy way to make pass)

2.3 removing duplication

We may be temped to jumping to the abstraction that solves multiple cases, and thats ok, but its important to be able to articulate intermediate TDD steps of everything solves the problem at hand

2.4 tolerating duplication

DRY is important, but if applied too early or with too much vigor, it  does nore harm than good

- Does the change make the code harder to understand?
- What is the future cost of doing nothing now?
- When will I have better information?

2.5 Hewing to the plan

express the unambiguous abstractions but avoid grasping for the not-quite visible ones

Readers of case statements expect conditions to be fundamentally the same.

sliding scale of concreteness/understandability <------------->abstractness/reusability

2.6 Exposing responsibilities

Duplication is useful when it supplies independent, specific examples of a general concept that you don’t yet understand.

Duplication is not helpful when it repeats known independent examples

2.7 choosing names

choose pulic interface of classes in a way that makes sense to sendesrs of messages and reduces knowledge required of sending classes

2.8 Revealing Intentions
The distinction between intention and implementation allows you to understand a computation first in essence and later in detail if needed

2.9 writing cost effective tests

When tests are tied too closely to code, every change in code engenders a change in test

2.10 avoiding echo chanmber

bottles = Bottles.new
3 assert_equal bottles.verses(99, 0), bottles.song

the song test is coupled to the current Bottles implementation such that it will break if the signature or behavior of verses changes, even if song continues to return the correct lyrics.

Best test is test WHOLE SONG as expectation

2.11 Considering Options
- Tie to bottles : Bad, can provide right output but test breaks if still working
- Tie to dynamicly genreated string ... duplicate verses logic
- Duplicate whoele string BEST hard to convince self

2.12 Summary

Code can be most cost effective if it is not clever or extensible but is easy to understand, cheap to write, and requirements dont change.
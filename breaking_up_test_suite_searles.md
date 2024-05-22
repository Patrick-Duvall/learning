# Test Double

## Relationships
Many right/wrong ways. Thoughtful and less thoughtful this is one.

Kent Beck: I get paid for code that works, not tests, so test as little as possible to meet needed confidence interval.
We code to solve problems

If you can solve a problem without code, its best.

## Infatuation
Love testing at first > Why does evey refactor break 6 tests
Why mocking methods on object under test
Now tests are an albatross

## Breakup
Team stop writing tests or delete specs.

## Why test
- know code works
- safely change/refactor
- tests encourage keep project simple
- make public api easy to use
- ensure behavior of other services
- ensure prod works
- narrowly specify 3rd party dependencies

Value in confidence, but also understanding.

## Single responsibility testing
Unclear tests *cost* money
- rediscover purpose => no value, costs time

every test suite => 1 type of confidence

| Layer | Spec |
|----------|----------|
| UI   | Cucumber   |
| Model  | Rails   |
| Controller   | Rails   |
| DB   |    |


Full rails stack is redundant test coverage, all tests go down to DB level

## Alternate app
Greatest test => does software serve purpose? Generate revenue? cut costs?

Top level of App 
 smoke/feature/acceptance tests, end to end tests
SAFE(acronym ^)

### Considerations on SAFE tests
- user (real world user)
- confidence = services glued together, app works
- understanding => how simple is our product

#### guidelines 
- should not know about internal API's (web tests bind user visible things, not markup)
- timebox on SAFEty test suite

#### warnings
Failures do to refactor are false negatives
Human intuition overvalues 'realistic' tests
Superlinear slowdown:
More tests => Slower Build + Bigger System => Slower Build

Safe tests are expensive and dont inform public API design

## Consumption Tests
Your things User
service => api client
UI => automated UI tool
- Verfies behavior directly responsible for
- Understanding => Is it usable

Module boundaries should be meaningful outside specs
Fake all external dependencies
Public, not private API's
If faked services, and its slow, thats your fault(indicative algorithmic complexity)
refactor safety net

If I fake out `/get Walrus` how do I know WalrusService returns walruses?
DO NOT WRITE interservice test
Tempting, but hard to setup, slow to run, and are redundant( with associated cost to change)
Root question is lack of trust, beef up walrus specs.

Trust other internal services(unless its inappropriate)
When trust not enough ...
## Contract Tests
Your use case, in someone else's repo
User => You
your needs become part of other repo's consumption suite

Confidence => Catch issues early (pre-release)
Learn => Is this service a good fit for our needs?
Repo owner learns how people use it

Written just like consumption tests
Not a replacement for human interaction :p

## TDD whats the point?
Lots of tests so far *but* no feedback of code design

## Discovery tests
Value of TDD is discovery of maintainable private API
User first person to use a non-existent method
concerned with inputs and outputs
concerned with basic code design details

Determines logical leaf nodes 
leads to small things/SRP
Seperation of roles

Command and query tests discover dependencies with doubles
logic tests discover implementation by usage (no doubles)

Pain is good, if its hard to write a test, it probably means our design could be improved

Discovery tests => small reusable units

Reuse overrated
 2 users, more churn

 Frameworks and discovery tests trying to solve same problem
 TDD is approach for discovering orderly structure

 mocking what you dont own is useless pain
 Wrap 3rd party api calls in adapters you own
 Mock these adapters
 When you want to respond to 3rd party api failures, write adapter specs
 Reduces cost of change later if encased in adapter object

check out growing object oriented software guided by tests

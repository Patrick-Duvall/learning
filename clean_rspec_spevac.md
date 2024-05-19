# Clean rspec

Revist Mets' idea 

Incoming message
  Query : assert result
  Command: Assert direct public side effects
Sent to self
  Ignore both
Outgoing
  Query: ignore (test in receiving class)
  Command: expect to send


The experience of going into an rspec file and not gaining any clarity

subject implicitly maps to instance of described class
(rubocop no implicit subject)

can name subject explicitly

described_class makes name changes in spec super easy

10% time spect writing, 90% spent reading, optimize code for reader

## Problem pattern

describe '#enrolls'
  it 'enrolls' # 'adds a participant to a workshop
  end
end

if you ever see a when in an if statement, consider using context instead

## 3 test phase (SEAT)
### Arrange(setup)
  setup only what needed
  let! == before, but with variable name
  before: set unreferenced state
  break each expectation into it's own it block
### Act(execute)
Do not asert, act, assert as a long cycle
### Assert
remove duplicative assertions
i.e. assert not empty, assert count == 1

Rails handles (T)eardown

Its difficult when let's are in a different place.. consider duplication
complicated tests indicative of code with many dependencies

shared examples: optimization for writer

test double judiciously
Mocking or stubbing object under test is red flag

expect_any_instance_of(Messenger).to_receive(:notify)
refactor to 
messenger = double
expect(Messenger).to_receive(:new).with(participant) { messenger }
expect(messenger).to_receive(:notify)



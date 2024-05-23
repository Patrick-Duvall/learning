# The magic tricks of testing

## Incoming Query Messages
Test incoming query messages by making assertions about what they send back

Test the interface, not the implementation

## Incoming Command messages
Test incoming command messages by making assertions about direct public side effects

Reciever of incoming message has sole responsibility for asserting the result direct public side effects

## Messages sent to self

- Do not test
Do not send expectation private method sent, binds you to current implementation
Do not make assertions about values, do not expect to sent them

caveat private algorithm early on

Do not let private tests keep people from improving your code

## Outgoing Query Methods
Do not assert result of outtgoing query. Trust the object that implements the query. Receiver of incoming query is solely responsible for assertions around state
Doing this is redundant and means you can't change implementation of this class without breaking tests.

Do not expect to send outgoing query, binds you to an implementation, makes it impossible to change code without breaking test

Do not test. One class' outgoing is another class' incoming

If a message has no visible side effects, the sender should not test it

## Outgoing command messages (methods with side effects)

Gear Send :changed to Observer

Expect to send outgoing command messages

Receiver has to receive message, or app will not be correct
Can be tempting to test side effect, but if you do, you are bound to the implementation of every object between the sender and the side effect. This is an integration test
Expect receiving object to receive with correct arguments. Depends on interface. Outgoing sender is responsible for sending command to receiver

### Observer stops implementing :changed

API drift

Mock is double, plays role of object, fake and real both promise implement common API

If you're going to do this, ensure the mock stays in sync (verified doubles)

## Takeaways

| Message | Query | Command |
| -------- | -------- | -------- |
| Incoming   | Assert Result   | Assert Direct public side effect   |
| Sent to self  | Ignore   | Ignore |
| Outgoing   | Ignore   | Expect to send verified double   |

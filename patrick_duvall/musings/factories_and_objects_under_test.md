# Factory Bot Factories seem problematic in terms of isolating the object under test

### Potential Problems

Implicit Dependencies:Factories can create implicit dependencies that are not immediately obvious. If a factory creates associated objects or sets default attributes, it can introduce dependencies that make tests harder to understand and maintain.

- Can be difficult to use factories with stubs and spies

Complexity: factories can lead to tests that are difficult to read and understand. when factory creates a large object graph its be hard to determine what is being tested and why.

### Other, unrelated reasons

- Performance (creating large networks of objects), especially when not needed for specific tests.
- When we have factories, we tend to always use them, even if we dont need everything they provide. Factories tend to be built with enough complexity to handle every use case


### Mitigations 

Use Traits: traits define variations of factories. Keep factories simple and focused on the specific test. If not every billing info needs a payment method, keep it in a trait.


#### Build vs. Create

When possible, use build

- Potential design smell: Factories HAVE to create a bunch of associated objects for model level validations to pass.
- Another issue: You HAVE to use #create because model lifecycle events do a bunch of data processing to get your models in the right state.

Be explicit about test setup. Instead of relying on factories to create associated objects, set up the necessary state directly in the test.

Keep factories simple. Do not add unnecessary attributes/associations most tests don't need. Rather, add those in the specific tests. Be comfortable not having a factory for everything. 

Possible: Avoid controller/requests specs that assert the object is created, consider asserting the objects class receives(:save) and returns true.

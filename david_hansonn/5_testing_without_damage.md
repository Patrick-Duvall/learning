# Testing wihtout damage

model and controller

Criticism of TDD is that stringent tests in total isolation with stubs

Majority of cases we should, test real things, hit DB, create models. Somehwat slow, can be made fast enough.

## Document feature

Can be locked (only one editor at a time)
Lockable concern

document has 3 boolean predicates that return true including `def subscribable = true`
includes `Subscribable`, which looks back to the document to see if it is subscribable, so does not maintain a master list of `subscribables`

```ruby
def subscribable?
  recordable.subscribable?
end
```

Recording has Many concerns, including Recordable and Lockable

```ruby
module Lockable
  extend ActiveSupport::Concern

  included do 
    has_one :lock, dependent: :destroy
  end

  def lock_by(user)
    transaction do
      create_lock! user unless user.locked?
    end
  end

  def locked?
    lock.present?
  end

  def locked_by(user)
    lock && lock.user == user
  end

  def unlock
    update! lock: nil
  end
end
```

## Lets look

create private session for new cookie to test lock

ONLY setup, set Current.person

NO factories, just vanilla rails fixtures.

Docs have a feature of versioning, old versions exist

`recordables` like `Documents`: immutable, recordings(versions): mutable, points to most recent immutable `Document`

```ruby
class DocumentTest
  test 'updating a document keeps the old version through past recordables' do
    recording = buckets(:anniversary).record Document.new(title: 'Funk!', content: 'Town')

    travel 5.seconds # account for order by created_at time stamp

    recording.update! recordable: Document.new(title: 'New order', content: 'This first')

    current_document = recording.reload.recordable_versions.first

    assert_equal 'New Order' current_document.title
    assert_equal 'This First' current_document.content.to_s

    previous_document = recording.reload.recordable_versions.second

    assert_equal 'Funk!' previous_document.title
    assert_equal 'Town' previous_document.content.to_s
  end
end
```
## Aside Google docs

HAs been in issue in Jira.. How does google docs get around this? # Not talk, Aside

Google docs

Each edit operation (insert, delete, format) is tracked with metadata
When conflicts occur, operations are "transformed" to maintain consistency
Example: If User A inserts "Hello" at position 5 and User B deletes characters 3-7, the system transforms these operations to work together

#### Fine-grained Locking/Presence

Paragraph/section-level locking: Lock only the specific paragraph being edited

#### Conflict Resolution Strategies
Last-write-wins with timestamps
Vector clocks to determine operation ordering
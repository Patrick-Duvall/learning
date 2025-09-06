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
Not true unit tests, hitting DB, as close to metal as possible.

## Running tests

Spring preloader - keeps persistant process for rails app in background so new spin up of app for tests

Lock Test `test/models/recording`

```ruby
class Recording::LockTest
  setup { Current.person = people('37s_david')}

  test 'locking a redording' do
    recordings(:planning_document).lock_by(users('37s_david'))
    assert recordings(:planning_document).locked?
    assert_equal users('37s_david'), redordings(:planning_document).lock.user
  end
end
```

Most of the assertions are super simple, asset and assert_equal

## Controller tests

```ruby
class DocumentsController
  include SetRecordable

  def create
    @recording = @bucket.record new_document, parent: @vault, status: status_param, subscribers: find_subscribers

    respond_to do |format|
      format.any(:html, :js) { redirect_to edit_subscriptions_or_recordable_url(@recording) }
      format.json { render :show, status: :created }
    end
  end
end
```

```ruby
class DocumentsControllerTest < ActionDispatch::IntegrationTest
  test 'creating a new document' do
    get new_bucket_vault_document_url(buckets(:anniversary), recordings(:anniversary_vault))
    assert_response :ok
    assert_breadcrumgs 'Docs & Files' # controller#new test, lots of UI elements
    # These render whole view and compile assets

    post bucket_vault_docuemnts_url(buckets(:anniversary), recordings(:anniversary_vault)), params: {
      document: { title: 'Hello World!', content: 'Yes yes' }
    }

    follow_redirect!
    assert_select 'h1', /Hello World!/
  end
end
```

step away from model tests, more of an integration/comprehensive
This is a form of integration test, stopping just short of using browser to drive test.

Not 1 assertion per test, but assert every relevent aspect of a specific action

Lock controller shows power of using concerns through generic object.

```ruby
class Recordings::LocksController
  def recording
    if @recording.locked?
      render
    else
      redirect_to @recording
    end
  end

  def destroy ; end #...
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


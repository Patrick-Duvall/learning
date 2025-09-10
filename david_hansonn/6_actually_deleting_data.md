# Deleting data

For many companies, when you delete an account, companies retain data

Don want to delete wrong stuff, want to delete everything.


In basecamp base data on `Account` w/module `Incineratable`.

```ruby
module Account::Incineratable
  INCINERATABLE_AT = 30.days

  included do
    set_callback(:cancel, :after) { incinerate_later }
  end

  def incinerate
    Incineration.new(self).run
  end

  private

  def incinerate_later
    Account::Incineratable.schedule(self) if canceled?
  end
end
```

Sets call back that after account is cancelled , command pattern
Job pattern where job is scheduled in future, long running queues

```ruby
class Account::IncinerateJob < ApplicaitonJob
  queue as :incineration
  retry on Recording::Incineratable::Incineration::RecordableNeedsIncineration

  def self.schedule(account)
    set(wait: Account::Incineratable::INCINERATABLE_AFTER).perform_later(account)
  end

  def perform(account)
    SignalId::Database.on_master { account.incinerate }
  end
end
```

`INCINERATABLE_AFTER` Lives in concern since used in multiple places


```ruby
class Account::Incineratalbe::Incineration
  def initialize(account)
    @account = account
  end

  def run
    if possible?
      incinerate_buckets
      incinerate_account
      incinerate_signal_account
    end
  end

  def possible?
    canceled? && due?
  end

  private
  # because things can change and it was enqueued earlier
  def due?
    @account.canceled_at < Account::Incineratable::INCINERATABLE_AFTER.ago.end_of_day
  end

  def canceled?
    @account.canceled && !@account.active
  end

  def incinerate_buckets
    @account.buckets.each do |bucket|
      Bucket::Incineratable::Incineration.new(bucket).run
    end
  end

  def incinerate_account
    @account.destroy
  end

  def incinerate_signal_account
    @account.signal_account.destroy if !Account.exists?(@account.id)
  end
end
```

Incinerating Buckets follows sme command pattern

```ruby
class Bucket::Incineratalbe::Incineration
  def initialze(bucket)
    @bucket = bucket
  end

  def run
    if possible?
      incinerate_recordings
      incinerate_bucket
    end
  end

  def possible?
    incineratable_via_self? || incineratable_via_account?
  end

  private

  def incineratable_via_self?
    @bucket.deleted && due? ?? !incineratable_via_account?
  end

  def incinerate_recordings
    @bucket.recordings.roots.each do |recording|
      Recording::Incineratable::Incineration.new(recording).run
    end
  end
end
```

Because Diffferent objects implement incineratable, you can delete a single recording, all the recordings in a bucket, or all the buckets with an account.
Recordings are messages, to dos, etc

Small optimize: order methods in order of use by main public method.


```ruby
class Recording::Incineratable::Incineration
  def initialize(recording)
    @recording = recording
  end

  def run
    if possible?
      incinerate_children(@recording)
      incinerate_dependents(@recording)
    end
  end

  def possible?
    incineratable_via_self? || incineratable_via_account?
  end

  private

  def has_incineratable_ancestor?
    @recording.ancestors.detect { |a| Recording::Incineratable::Incineration.new(a).possible? } 
  end

  def incinerate_children(recording)
    @recording.descendants.each do |child|
      incinerate_dependents(child)
    end
  end

  def incinerate_dependents(recording)
    Bucket.no_touching do
      Recording.no_touching do
        incinerate_recordables(recording) # Question why not just make this an attr accessor and not pass? Guess: Ordering on destroy?

        incinerate_recording(recording)
      end
    end
  end
  # ...
end
```

When deleting whole tree, don't want children out of order, have consideration of incineratable ancestors
AR default is deleting a child touches the parent, but we dont want parents considered touched because eash touch is update SQL query

Recordable is where actual data lies

```ruby
class Recordable::Incineration
  def initialize(recording, recordable)
    @recording = recording
    @recordable = recordable
  end

  def run
    @recordable.destroy if possible?
  end

  def possible?
    !referenced_currently_by_other_recordings && !referenced_currently_by_other_events?
  end

  #...
end
```

Can invoke this style from anywhere in heirarchy

Bucket delete has 2 steps: trashed (soft delete, in trashcan), and incinerated: GONE

```ruby
module Bucket::Incineratable

  DELETABLE_AFTER = 25.days
  INCINERATABLE_AFTER = 5.days # 5 day buffer before gone forever

  included do
    after_update_commit :change_trashed_to_deleted_later, if: :changed_to_trashed?
    after_update_commit :incinerate_later, if: :changed_to_deleted?
  end

  def delete
    Deletion.new(self).run
  end

  def incinerate
    Incineration.new(self).run
  end

  private
  def chage_trashed_to_deleted_later
    Bucket::ChangeTrashedToDeletedJob.schedule(self)
  end

  def incinerate_later
    Bucket::IncinerateJob.schedule(self)
  end
end
```

In single DB cant really recover data, try to follow principle of truly deleting while not being onerous. DB backups wiped every 30 days

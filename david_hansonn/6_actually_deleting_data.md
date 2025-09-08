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
end
```

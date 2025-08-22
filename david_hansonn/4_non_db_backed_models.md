# Non DB backed models

https://www.youtube.com/watch?v=hkmrfjex7jI&list=PL9wALaIpe0Py6E_oHCgTrD6FvFETwJLlx&index=4

## What to put in app/models

Not just DB backed records

Some of the rails core classes have hundreds of methods. High surface area does no *necesarily* mean a bad model.

Broad surface area on core models because we can put all difference code in concerns. Natural API. Mix-ins + backing classes.

### Notifiee (one who is notified)

```ruby
# This is the whole user class
class User
include Notifiee
# ~15 includes

def enroll

def attributes_for_person

def settings
```

```ruby
module User::Notifiee
  def notificaitons
    @notifications ||= User:::Notifications.new(self)
  end
end

```

Above provides for `.` access vs `::` access. Focus on usable public API for classes

Notifiee is PORO

```ruby
class User::Notifications
  def scheduled
  def snoozed
  def granularity
    @granulaty ||= User::Notifications::Granularity.new(self)
  end
end
```

```ruby
class User::Notifications::Granularity # what we get notifications about(i.e. everything, certain channels, @'s)
# Poro, takes as only param notifications, determines when to notify based on possible notifications
  attr_reader :notifications
  delegate :user, :redis, to: :notifications

  def allows?(deliverable)
    case
    when everything?
    true
    when pings_and_mentions
      deliverable.is_a?(Mention) || ping?(deliverable) # class check here. "Bad" from traditional OOP. May not be worth teasing an abstraction.
    end
  end

  private

  def granularity_key
    "#{notifications.send(:user_key)}/granularity" # Calling private method from notification. In same domain better than alternative of exposing granularity_key in notifications. (would imply should be available at say the controller level).
  end
end
```

### When redis vs DB

DB: Store of record, content posted to Basecamp (messages, files etc)

Vs Settings of when a person wants records. Tier below grade of criticality, less bad to lose. Redis is stable.
Redis is server-side caching, layer between user and slower parts of App (DB, ceratain expensive method calls.)

```ruby
class My::Notifications::SettingsController
  def update
    #...
    update_granularity
  end

  def update_granularity
    Current.user.notifications.granularity.choice = params[:granularity]
  end
end
```

Having a beautiful, simple API is worth a lot

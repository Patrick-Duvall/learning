# Moving Specifics down

Key aspect is learning to rewrite/extend software

Clean code is useless if not easily changed

Seeing things as a reviewer -- furhter back

Concept of asking questions about what people have worked on during the day. Do not want to send notificaiton if quetion answered(system seems dumb then).

First blush.. go to the source and add a conditional

```ruby
# reminder_delivery.rb
def deliver
  super && question_answered?
end

def question_answered? # change with call above
  recording.question? && Question::Answer::Entry.for(deliverable).answer_recording
  #type check
end

# entry.rb

class << self
  def for(reminder)
    new reminder.recording, person: reminder.person, group_on: reminder.localized_remind_at.to_date
  end
end
```

Delivery is generic. Questionable to add conditionals on types higher up in the code base. ReminderDelivery should not need to know question specifics

2nd blush, add a check on reminder prior to sending to reminder_delivery

```ruby
# reminder.rb
def pertinent?
  recording.recordable.reminder_pertinent?(self)
end

def deliverable?
  scheduled? && eligible_recording? && eligible_remindee? && pertinent?
end
```

Should the reminder answer the question of if self is pertinent?

Want to abstract notion of Pertinent and push down to most concrete level.

```ruby
#question.rb

def reminder_pertinent?
  !Question::Answer::Entry.for(reminder).answer_recording
end
#polymorphism instead of type check
```

Any time you see a type check is a smell suggesting you can use message passing instead

In some ways, the first implementation is clearer, responsiblity is not diffuse across objects. HOWEVER there are lots of reasons the reminder logic might change i.e. answered today, answered recently etc. that are not the purview of the reminder delivery. When we isolate them, we can make changes to the small specific class that plays this role.

Rather than a `!Question::Answer::Entry.for(reminder).answer_recording` use `Question::Answer::Entry.for(reminder).answer_recording.blank?` slower.. yes, but more idiomatic.

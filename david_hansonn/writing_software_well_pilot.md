# Video
[LINK](https://www.youtube.com/watch?v=H5i1gdwe1Ls)

## Code comments

More often see as smell

Bucket, concept around user including their accesses, readings, bookmarks, email dropboxes

When removed from bucket change premissions/accesses vie Person::RemoveInaccessibleRecords in Background job.

```ruby
def remove_inaccessable_records
 # 30 sec grace period in case of accidental removal
  Person::RemoveInaccessibleRecords.set(wait: 30.seconds).perform_later(person, bucket)
```

Comment here is really explaining the `30 seconds` reasoning. Extract explaining variable => Extract to named const.(Put in correct private/public scope)

Feel free to move private methods, put callbacks in order declared, put others in order of use as table of contents
Not really capturable by auto style checker

Counter: helpful for AI

## Extracting things into rails

Account
had many administrators through administratorships

`find_or_create_by` createss a DB TXN Finds, THEN creates, can be a stale read for busy applicaitons
Better: try to create, rely on unique index in DB to throw an exception


```ruby
#  tries to create a new record, if uiniqueness constraint fails, return record. Implemented in rails 6 as `create_or_find_by`
def grant person:
  find_or_create person:
rescue ActiveRecord::NotUinique
  where(person:).take
end
```

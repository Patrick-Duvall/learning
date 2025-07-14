# Callbacks
David Heinemeier Hansson
[LINK](https://www.youtube.com/watch?v=m1jOWu7woKM)

Callbacks: Move incidental complexity to side.

### Mentions feature

- in app/email/sms etc

MessagesController#create

creating mentions, belong to recording
mentionee, mentioner, both FK's on Person

Mentions includes Recording concern (Orthogonal to main responsibility) chat could be a recording.
Module Recording::Mentions
after commit evesdrop for mentions if eavesdropping

Evesdropping: methods around AR dirty checking changed attributes

bucket.recording.save recordning has mention concern, concern fires after commit callback based on eavesdropping, after commit needs AR dirty

Callbacks + jobs, fire the mention creation into a job, job generates mention (and notification)
Evesdroipping job thin shell to instantiate Evesdropper

Messages controller #create
 Mentions concern on recording
   Enqueues job
     Calls Service object

Allows us to ignore complexity of mentions for most use cases

Use `Current` for global that are only set 1x in a lifecycle request. (Not for jobs/across environments)

Service object takes mentioner, mentionees, recording, creates `Mention`

Mention has after commit deliver hook that enqueues a job to async fire the mention communications i.e. sms, email, push

Copier class with supression to not fire callbacks for old mentions

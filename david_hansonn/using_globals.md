# Using globals when the Price is right

Make sense when its the same through life of request

Just because it ban be a mess, doesnt mean dont use it when its not a good fit (sharp knife)

Base Camp Current
Auth: user, account, 
Request Details: request_id, user_agent, ip_address

If hasnt been set, (jobs) set with `person=`

Application controller just a bucket of concerns


`SetCurrentRequestDetails`: Set request detail globals
request_id for locking

`Authorization`
If oauth? or cookies?
  permitted
else
  request_api_auth || request_cookie_auth
end

Eventually
#authenticated sets Current.person

## What can we use these globals for?

Event Tracking, class that tracks what changes (side effect)
#track_event(created:, status:)
Sets Creator Current.person

Also, tie request details to every event

Hides this side effect from reading the code, I.e. creating a record, we don't want all the methods to pass these details through scope gates to Event tracking.

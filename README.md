# Mailshake Ruby

Ruby gem for the [Mailshake](https://mailshake.com) email outreach API.

## Installation

Add to your Gemfile:

```ruby
gem 'mailshake-ruby'
```

Then run:

```
bundle install
```

Or install directly:

```
gem install mailshake-ruby
```

## Configuration

```ruby
Mailshake.configure do |config|
  config.api_key = ENV['MAILSHAKE_API_KEY']
end
```

## Usage

All API responses return model objects with snake_case accessors and nested model hydration. Hash-style access (`result["key"]`) is still supported for backwards compatibility.

### Campaigns

```ruby
campaigns = Mailshake::Campaigns.new

list = campaigns.list(search: "onboarding", per_page: 10)
list.each { |c| puts c.title }

campaign = campaigns.get(campaign_id: 1)
campaign.title                    # => "Q2 Outreach"
campaign.is_paused                # => false
campaign.sender.email_address     # => "sales@company.com"
campaign.messages.first.subject   # => "Hey {{first}}"

campaigns.create(title: "Q2 Outreach", sender_id: 5)
campaigns.pause(campaign_id: 1)
campaigns.unpause(campaign_id: 1)

export = campaigns.export(campaign_ids: [1, 2], export_type: "csv", timezone: "US/Pacific")
status = campaigns.export_status(status_id: export.check_status_id)
puts status.csv_download_url if status.is_finished
```

### Recipients

```ruby
recipients = Mailshake::Recipients.new

result = recipients.add(campaign_id: 1, addresses: [{ emailAddress: "john@example.com" }])
status = recipients.add_status(status_id: result.check_status_id)

list = recipients.list(campaign_id: 1, filter: "active", per_page: 25)
list.each { |r| puts "#{r.full_name} <#{r.email_address}>" }

recipient = recipients.get(recipient_id: 100)
recipient.email_address  # => "john@example.com"
recipient.is_paused      # => false

recipients.pause(campaign_id: 1, email_address: "john@example.com")
recipients.unpause(campaign_id: 1, email_address: "john@example.com")
recipients.unsubscribe(email_addresses: ["john@example.com"])
```

### Activity

```ruby
activity = Mailshake::Activity.new

sent = activity.sent(campaign_id: 1, per_page: 50)
sent.each { |msg| puts "#{msg.subject} -> #{msg.recipient.email_address}" }

opens = activity.opens(campaign_id: 1, exclude_duplicates: true)
opens.each { |o| puts "#{o.recipient.email_address} opened at #{o.action_date}" }

clicks = activity.clicks(campaign_id: 1, match_url: "https://example.com")
clicks.each { |c| puts "#{c.recipient.email_address} clicked #{c.link}" }

replies = activity.replies(campaign_id: 1, reply_type: "reply")
replies.each { |r| puts "#{r.recipient.email_address}: #{r.plain_text_body}" }

activity.created_leads(campaign_id: 1, since: "2026-01-01")
activity.lead_assignments(campaign_id: 1)
activity.lead_status_changes(campaign_id: 1)
```

### Leads

```ruby
leads = Mailshake::Leads.new

list = leads.list(campaign_id: 1, status: "open")
list.each do |lead|
  puts "#{lead.recipient.email_address} - #{lead.status}"
  puts "  assigned to: #{lead.assigned_to&.full_name}"
end

lead = leads.get(lead_id: 42)
lead.status                   # => "open"
lead.recipient.email_address  # => "john@example.com"
lead.campaign.title           # => "Q2 Outreach"

leads.create(campaign_id: 1, email_addresses: ["john@example.com"])
leads.close(lead_id: 42, status: "won")
leads.ignore(lead_id: 42)
leads.reopen(lead_id: 42)
```

### Team

```ruby
team = Mailshake::Team.new

members = team.list_members(search: "john", per_page: 10)
members.each { |u| puts "#{u.full_name} <#{u.email_address}>" }
```

### Senders

```ruby
senders = Mailshake::Senders.new

list = senders.list(search: "sales", per_page: 10)
list.each { |s| puts "#{s.from_name} <#{s.email_address}>" }
```

### Push/Webhooks

```ruby
push = Mailshake::Push.new

push.create(target_url: "https://example.com/webhook", event: "reply")
push.delete(target_url: "https://example.com/webhook")
```

### Me

```ruby
client = Mailshake.client
user = client.me
user.full_name      # => "Eduardo Souza"
user.email_address  # => "eduardo@example.com"
user.is_team_admin  # => true
```

## Models

All responses are wrapped in model objects under `Mailshake::Models`. Models provide:

- **Snake_case accessors** - `campaign.is_paused` instead of `campaign["isPaused"]`
- **Nested model hydration** - `lead.recipient.email_address` returns a `Recipient` model
- **Backwards compatibility** - `campaign["title"]` still works
- **`to_h`** - convert back to the original hash

See the [full model reference](https://github.com/ESouza/mailshake-ruby/wiki/Models) in the wiki.

## Pagination

List endpoints return a `Models::List` object with `Enumerable` support:

```ruby
result = campaigns.list(per_page: 10)
result.each { |c| puts c.title }
result.map(&:title)

# Paginate through all results
all = []
result = campaigns.list(per_page: 25)
all.concat(result.results)

while result.next_token
  result = campaigns.list(per_page: 25, next_token: result.next_token)
  all.concat(result.results)
end
```

## Error Handling

```ruby
begin
  campaigns.get(campaign_id: 999)
rescue Mailshake::AuthenticationError => e
  puts "Bad API key"
rescue Mailshake::NotFoundError => e
  puts "Not found: #{e.message}"
rescue Mailshake::RateLimitError => e
  puts "Rate limited, retry after: #{e.retry_after}"
rescue Mailshake::ValidationError => e
  puts "Validation errors: #{e.errors}"
rescue Mailshake::APIError => e
  puts "API error #{e.status_code}: #{e.message}"
end
```

## License

MIT License. See [LICENSE.txt](LICENSE.txt).

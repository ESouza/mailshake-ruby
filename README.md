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

### Campaigns

```ruby
campaigns = Mailshake::Campaigns.new

campaigns.list(search: "onboarding", per_page: 10)
campaigns.get(campaign_id: 1)
campaigns.create(title: "Q2 Outreach", sender_id: 5)
campaigns.pause(campaign_id: 1)
campaigns.unpause(campaign_id: 1)
campaigns.export(campaign_ids: [1, 2], export_type: "csv", timezone: "US/Pacific")
campaigns.export_status(status_id: 42)
```

### Recipients

```ruby
recipients = Mailshake::Recipients.new

recipients.add(campaign_id: 1, addresses: [{ emailAddress: "john@example.com" }])
recipients.add_status(status_id: 42)
recipients.list(campaign_id: 1, filter: "active", per_page: 25)
recipients.get(recipient_id: 100)
recipients.pause(campaign_id: 1, email_address: "john@example.com")
recipients.unpause(campaign_id: 1, email_address: "john@example.com")
recipients.unsubscribe(email_addresses: ["john@example.com"])
```

### Activity

```ruby
activity = Mailshake::Activity.new

activity.sent(campaign_id: 1, per_page: 50)
activity.opens(campaign_id: 1, exclude_duplicates: true)
activity.clicks(campaign_id: 1, match_url: "https://example.com")
activity.replies(campaign_id: 1, reply_type: "reply")
activity.created_leads(campaign_id: 1, since: "2026-01-01")
activity.lead_assignments(campaign_id: 1)
activity.lead_status_changes(campaign_id: 1)
```

### Leads

```ruby
leads = Mailshake::Leads.new

leads.list(campaign_id: 1, status: "open")
leads.get(lead_id: 42)
leads.create(campaign_id: 1, email_addresses: ["john@example.com"])
leads.close(lead_id: 42, status: "won")
leads.ignore(lead_id: 42)
leads.reopen(lead_id: 42)
```

### Team

```ruby
team = Mailshake::Team.new

team.list_members(search: "john", per_page: 10)
```

### Senders

```ruby
senders = Mailshake::Senders.new

senders.list(search: "sales", per_page: 10)
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
client.me
```

## Pagination

Endpoints that return lists support pagination via `next_token` and `per_page`:

```ruby
result = campaigns.list(per_page: 10)
next_page = campaigns.list(per_page: 10, next_token: result["nextToken"])
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

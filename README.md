# OmniAuth Bolt

This gem contains the Bolt strategy for OmniAuth.


## Before You Begin

You should have already installed OmniAuth into your app; if not, read the [OmniAuth README](https://github.com/omniauth/omniauth) to get started.

# Link the Bolt documentation page
## Using This Strategy

First start by adding this gem to your Gemfile:

```ruby
gem 'omniauth-bolt'
```

If you need to use the latest HEAD version, you can do so with:

```ruby
gem 'omniauth-bolt', :github => 'nebulab/ominauth-bolt'
```

Next, tell OmniAuth about this provider. For a Rails app, your `config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :bolt, "API_KEY", "PUBLISHABLE_API"
end
```

Replace `"API_KEY"` and `"PUBLISHABLE_KEY"` with the appropriate values you obtained [earlier](https://merchant.bolt.com/developers).

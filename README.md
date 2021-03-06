# Searchjoy

Search analytics made easy

[See it in action](http://searchjoy.herokuapp.com/)

- view searches in real-time
- track conversions week over week
- monitor the performance of top searches

Works with Rails 3.1+ and any search engine, including Elasticsearch, Sphinx, and Solr

:cupid: An amazing companion to [Searchkick](https://github.com/ankane/searchkick)

:tangerine: Battle-tested at [Instacart](https://www.instacart.com/opensource)

## Get Started

Add this line to your application’s Gemfile:

```ruby
gem "searchjoy"
```

And run the generator. This creates a migration to store searches.

```sh
rails generate searchjoy:install
rake db:migrate
```

Next, add the dashboard to your `config/routes.rb`.

```ruby
mount Searchjoy::Engine, at: "admin/searchjoy"
```

Be sure to protect the endpoint in production - see the [Authentication](#authentication) section for ways to do this.

### Track Searches

Track searches by creating a record in the database.

```ruby
Searchjoy::Search.create(
  search_type: "Item", # typically the model name
  query: "apple",
  results_count: 12
)
```

With [Searchkick](https://github.com/ankane/searchkick), you can use the `track` option to do this automatically.

```ruby
Item.search "apple", track: true
```

If you want to track more attributes, add them to the `searchjoy_searches` table.  Then, pass the values to the `track` option.

```ruby
Item.search "apple", track: {user_id: 1, source: "web"}
```

It’s that easy.

### Track Conversions

First, choose a conversion metric. At Instacart, an item added to the cart from the search results page counts as a conversion.

Next, when a user searches, keep track of the search id. With Searchkick, you can get the id with `@results.search.id`.

When a user converts, find the record and call `convert`.

```ruby
search = Searchjoy::Search.find params[:id]
search.convert
```

Better yet, record the model that converted.

```ruby
item = Item.find params[:item_id]
search.convert(item)
```

### Authentication

Don’t forget to protect the dashboard in production.

#### Basic Authentication

Set the following variables in your environment or an initializer.

```ruby
ENV["SEARCHJOY_USERNAME"] = "andrew"
ENV["SEARCHJOY_PASSWORD"] = "secret"
```

#### Devise

```ruby
authenticate :user, lambda{|user| user.admin? } do
  mount Searchjoy::Engine, at: "admin/searchjoy"
end
```

### Customize

#### Time Zone

To change the time zone, create an initializer `config/initializers/searchjoy.rb` with:

```ruby
Searchjoy.time_zone = "Pacific Time (US & Canada)" # defaults to Time.zone
```

#### Top Searches

Change the number of top searches shown with:

```ruby
Searchjoy.top_searches = 500 # defaults to 100
```

#### Live Conversions

Show the conversion name in the live stream.

```ruby
Searchjoy.conversion_name = proc{|model| model.name }
```

## TODO

- customize views
- analytics for individual queries
- group similar queries
- track pagination, facets, sorting, etc

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/searchjoy/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/searchjoy/pulls)
- Write, clarify, or fix documentation
- Suggest or add new feature

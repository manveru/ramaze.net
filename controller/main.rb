class MainController < Controller

  layout '/layout/main'

  before_all do
    @current = Ramaze::Action.current.name
    @menu = [
      { :text => 'Home',      :href => '/',                                },
      { :text => 'Download',  :href => '/download',                        },
      { :text => 'Features',  :href => '/features',                        },
      { :text => 'Learn',     :href => '/learn',                           },
      { :text => 'Community', :href => '/community',                       },
      { :text => 'Code',      :href => 'http://github.com/manveru/ramaze', },
    ]
    item = @menu.find { |item| item[ :href ] == "/#{@current}" } || @menu[ 0 ]
    item[ :class ] = 'current'
  end

  private

  def show_feed(desc, link)
    cache = Ramaze::Cache.feed

    if content = cache[link]
      content
    else
      content = build_feed(link, desc)
      cache.store(link, content, :ttl => 600)
    end

    content
  end

  def build_feed(link, desc)
    feed = FeedConvert.parse(open(link))

    b = Builder::XmlMarkup.new

    b.div(:class => 'feed') do |div|
      div.h2 do |h2|
        h2.a(feed.title, :href => feed.link)
        h2.a(:href => link) do |a|
          a.img(:src => '/images/base/20x20_rss-feed.png')
        end
      end

      b.ul do
        feed.items.map do |item|
          b.li do
            b.span( item.time.strftime( '%Y-%m-%d' ), :class => 'date' )
            b.a(item.title, :href => item.link)
          end
        end
      end
    end

    b.target!
  end
end

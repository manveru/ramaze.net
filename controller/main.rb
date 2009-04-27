class MainController < Controller
  layout 'main'

  before_all do
    @current = Ramaze::Current.action.name.sub(/^\//, '')
    @menu = [
      { :text => 'Home',      :href => '/',                                },
      { :text => 'Download',  :href => '/download',                        },
      { :text => 'Features',  :href => '/features',                        },
      { :text => 'Learn',     :href => '/learn',                           },
      { :text => 'Community', :href => '/community',                       },
      { :text => 'Code',      :href => 'http://github.com/manveru/ramaze', },
    ]
    item = @menu.find { |item| item[ :href ] == "/#{@current}" } || @menu[ 0 ]
    p :current => @current
    p :item => item
    item[ :class ] = 'current'
  end

  private

  def show_feed(desc, link, is_twitter = false)
    cache = Ramaze::Cache.feed

    if content = cache[link]
      content
    else
      content = build_feed(link, desc, is_twitter)
      cache.store(link, content, :ttl => 600)
    end

    content
  end

  def lengthen_url(url)
    require 'open-uri'
    require 'json'
    open( "http://www.longurlplease.com/api/v1.1?q=#{ u( url ) }" ) do |http|
      hash = JSON.parse(http.read)
      hash.values[0] || url
    end
  end

  def build_feed(link, desc, is_twitter = false)
    b = Builder::XmlMarkup.new

    b.div(:class => 'feed') do |div|
      begin
        Timeout::timeout( 11 ) do
          feed = FeedConvert.parse(open(link))

          div.h2 do |h2|
            h2.a(feed.title, :href => feed.link)
            h2.a(:href => link) do |a|
              a.img(:src => '/images/base/20x20_rss-feed.png')
            end
          end

          b.ul do
            feed.items.map do |item|
              b.li do
                if is_twitter
                  b.span( item.time.strftime( '%Y-%m-%d' ), :class => 'date' )
                  title = item.title.gsub( /^ramazenews: /, '' )
                  title.scan( /\S+/ ) { |word|
                    if word =~ %r{^http://}
                      url = lengthen_url(word)
                      b.a( "#{url} ", :href => url )
                    else
                      b.span( "#{word} " )
                    end
                  }
                else
                  b.span( item.time.strftime( '%Y-%m-%d' ), :class => 'date' )
                  b.a(item.title, :href => item.link)
                end
              end
            end
          end
        end
      rescue Timeout::Error
        div.h2 do |h2|
          h2.a(desc, :href => link)
          h2.a(:href => link) do |a|
            a.img(:src => '/images/base/20x20_rss-feed.png')
          end
        end
        b.span('(feed unreachable)')
      end
    end

    b.target!
  end
end

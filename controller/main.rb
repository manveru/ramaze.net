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
    item[ :class ] = 'current'
  end

  private

  FEED_CACHE = {}
  FEED_MTIME = Hash.new{|k,v| k[v] = Time.now }

  def show_feed(desc, link, is_twitter = false)
    if content = FEED_CACHE[link]
      if FEED_MTIME[link] + 1800 < Time.now # every 30 minutes
        # set first so it's harder to have two builds at once
        FEED_MTIME[link] = Time.now

        # build in background, show older contents
        Thread.new do
          FEED_CACHE[link] = build_feed(link, desc, is_twitter)
        end
      end
    else
      Ramaze::Log.debug "build #{link} for the first time"
      content = FEED_CACHE[link] = build_feed(link, desc, is_twitter)
      FEED_MTIME[link] = Time.now
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
  rescue OpenURI::HTTPError
    url
  end

  def build_feed(link, desc, is_twitter = false)
    builder = Nokogiri::XML::Builder.new{|b|
      b.div(:class => 'feed') do |div|
        feed = open(link){|io| FeedConvert.parse(io) }

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
    }

    builder.to_xml
  end
end

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

end

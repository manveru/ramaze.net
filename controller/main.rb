class MainController < Controller
  layout '/layout/main'

  before_all do
    @current = Ramaze::Action.current.name
  end

  def learn__getting_started
    mkd 'learn/getting-started'
  end
end

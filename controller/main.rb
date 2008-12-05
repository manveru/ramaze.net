class MainController < Controller
  layout '/layout/main'

  before_all do
    @current = Ramaze::Action.current.name
  end
end

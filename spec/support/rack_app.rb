class RackApp
  attr_reader :last_value, :store_active

  def call(env)
    LiveQA::Store.store[:foo] ||= 0
    LiveQA::Store.store[:foo] += 1

    @last_value = LiveQA::Store.store[:foo]

    raise 'ERROR' if env[:error]
  end
end

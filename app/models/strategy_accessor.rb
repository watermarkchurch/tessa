module StrategyAccessor

  def strategy(db=STRATEGIES)
    db.strategies[strategy_name.to_sym]
  end

end

shared_examples_for "strategy lookup method" do
  let(:strategy_class) { Class.new(Strategy) }
  before do
    strategy_class.add :default, {}
  end

  context "with a configured strategy name" do
    subject(:strategy) { target.strategy(strategy_class) }
    before { args[:strategy_name] = "default" }
    it { is_expected.to be_a(Strategy) }
  end

  context "with an unknown strategy name" do
    subject(:strategy) { target.strategy(strategy_class) }
    before { args[:strategy_name] = "unknown" }
    it { is_expected.to be_nil }
  end

  context "with default strategy db" do
    subject(:strategy) { target.strategy }
    before do
      args[:strategy_name] = "test_#{rand(10000)}"
      STRATEGIES.add target.strategy_name, {}
    end

    it { is_expected.to be_a(Strategy) }
  end
end

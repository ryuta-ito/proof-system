class Sequents
  attr_accessor :sequents, :rule_name

  include ActiveModel::Model

  def self.build_empty
    new sequents: [], rule_name: ''
  end

  def assumption
    if sequents.first
      sequents.first.assumption
    else
      Sequent::Assumption.build_empty
    end
  end

  def consequece
    if sequents.first
      sequents.first.consequece
    else
      Sequent::Consequence.build_empty
    end
  end
end

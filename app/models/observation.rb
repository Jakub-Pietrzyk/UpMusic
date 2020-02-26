class Observation
  include Mongoid::Document
  belongs_to :observed_by, class_name: "User", inverse_of: :give_observations
  belongs_to :being_observed, class_name: "User", inverse_of: :observations
end

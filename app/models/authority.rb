class Authority
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
  include Mongoid::Ancestry
  has_ancestry
  field :version,               type: Integer
  
end
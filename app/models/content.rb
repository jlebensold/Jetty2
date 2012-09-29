class Content 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  store_in :contents
  field :version, type: Integer
  field :title, type: String
  field :text, type: String 

end
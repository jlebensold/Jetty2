class Note 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes

  store_in :notes
  field :version,               type: Integer
  field :start_paragraph_char,  type: Integer
  field :start_paragraph,       type: Integer
  field :end_paragraph,         type: Integer
  field :end_paragraph_char,    type: Integer
  field :raw_range,             type: Array
  field :authorities,           type: Array
  field :text,                  type: String
  field :collapsed,             type: Boolean
  belongs_to :content
end
class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :channel, type: String # email ou whatsapp
  field :destination, type: String
  field :relationship, type: String
  field :notified, type: Boolean, default: false
  field :notified_at, type: Time
  
  belongs_to :memorial
  
  validates :name, :channel, :destination, presence: true
  validates :channel, inclusion: { in: %w[email whatsapp] }
end

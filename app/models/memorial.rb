class Memorial
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :deceased_name, type: String
  field :birth_date, type: String
  field :death_date, type: String
  field :memories, type: String
  
  # Memorial content
  field :title, type: String
  field :biography_summary, type: String
  field :life_history, type: String
  field :quote, type: String
  field :keywords, type: Array
  
  # Event content
  field :wake_details, type: Hash
  field :burial_details, type: Hash
  field :stream_details, type: Hash
  field :offerings_options, type: Array
  field :schedule_summary, type: String
  
  # Page content
  field :page_slug, type: String
  field :html_content, type: String
  field :css_content, type: String
  field :js_content, type: String
  field :page_url, type: String
  
  field :status, type: String, default: 'draft'
  field :notified_count, type: Integer, default: 0
  
  has_many :contacts, dependent: :destroy
  
  index({ page_slug: 1 }, { unique: true, sparse: true })
  
  validates :deceased_name, presence: true
  
  before_create :generate_slug
  
  private
  
  def generate_slug
    return if page_slug.present?
    base = deceased_name.to_s.parameterize
    self.page_slug = "#{base}-#{SecureRandom.hex(4)}"
  end
end

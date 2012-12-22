class Commit < ActiveRecord::Base
  
  belongs_to :release
  has_and_belongs_to_many :tickets
  
  after_create :associate_tickets_with_self
  
  delegate :project, :to => :release
  
  
  
  def self.attributes_from_native_commit(native)
    { :sha => native.sha,
      :message => native.message,
      :date => native.date,
      :committer => native.author_name,
      :committer_email => native.author_email }
  end
  
  def native_commit
    project.repo.native_commit(sha)
  end
  
  
  
  def skip?
    merge? || tags.member?("skip")
  end
  
  def merge?
    message =~ MERGE_COMMIT_PATTERN
  end
  
  
  
  def tags
    parsed_message[:tags]
  end
  
  def clean_message
    parsed_message[:clean_message]
  end
  
  def ticket_numbers
    parsed_message[:tickets]
  end
  
  def extra_attributes
    parsed_message[:attributes]
  end
  
  
  
  def self.parse_message(message)
    tags = []
    tickets = []
    attributes = {}
    clean_message = message.dup
    
    clean_message.gsub!(TICKET_PATTERN) { tickets << $1; "" }
    clean_message.gsub!(EXTRA_ATTRIBUTE_PATTERN) { (attributes[$1] ||= []).push($2); "" }
    while clean_message.gsub!(TAG_PATTERN) { tags << $1; "" }; end
    
    {tags: tags, tickets: tickets, attributes: attributes, clean_message: clean_message.strip}
  end
  
  TICKET_PATTERN = /\[#(\d+)\]/
  
  EXTRA_ATTRIBUTE_PATTERN = /\{\{([^:\}]+):([^\}]+)\}\}/
  
  TAG_PATTERN = /^\s*\[([^\]]+)\]\s*/
  
  MERGE_COMMIT_PATTERN = /^Merge (remote-tracking )?branch/
  
  
  
private
  
  
  
  def parsed_message
    @parsed_message ||= self.class.parse_message(message)
  end
  
  
  
  def associate_tickets_with_self
    return if ticket_numbers.empty?
    
    project.find_or_create_tickets_by_number(ticket_numbers).each do |ticket|
      ticket.commits << self unless ticket.commits.exists?(id)
    end
  end
  
  
  
end

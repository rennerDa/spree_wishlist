class Wishlist < ActiveRecord::Base
  belongs_to :user
  has_many :wished_products
  before_create :set_access_hash
  
  def to_param
    self.access_hash
  end  

  def can_be_read_by?(user)
    !self.is_private? || user == self.user
  end
  
  def is_default=(value)
    self['is_default'] = value
    if self.is_default?
      Wishlist.update_all({:is_default => false}, ["id != ? AND is_default = ? AND user_id = ?", self.id, true, self.user_id])
    end
  end
  
  private
  
  def set_access_hash
    self.access_hash = Digest::SHA1.hexdigest("--#{user_id}--#{user.salt}--#{Time.now}--")
  end
end
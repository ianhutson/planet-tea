class User < ActiveRecord::Base
    has_secure_password
    validates_uniqueness_of :username, :allow_blank => false
    has_many :reviews
  end
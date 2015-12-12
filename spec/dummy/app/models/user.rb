class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  include EnjuLeaf::EnjuUser
  include EnjuMessage::EnjuUser
  include EnjuCirculation::EnjuUser
  enju_bookmark_user_model
end

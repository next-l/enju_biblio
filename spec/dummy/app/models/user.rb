class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  include EnjuSeed::EnjuUser
  include EnjuMessage::EnjuUser
end

Manifestation.include(EnjuSubject::EnjuManifestation)
Manifestation.include(EnjuNdl::EnjuManifestation)
Profile.include(EnjuLibrary::EnjuProfile)
Item.include(EnjuLibrary::EnjuItem)

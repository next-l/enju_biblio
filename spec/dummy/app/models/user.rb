class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  include EnjuSeed::EnjuUser
  include EnjuMessage::EnjuUser
  include EnjuCirculation::EnjuUser
  include EnjuBookmark::EnjuUser
end

CarrierType.include(EnjuCirculation::EnjuCarrierType)
Manifestation.include(EnjuCirculation::EnjuManifestation)
Manifestation.include(EnjuSubject::EnjuManifestation)
Manifestation.include(EnjuNdl::EnjuManifestation)
Item.include(EnjuCirculation::EnjuItem)
Item.include(EnjuLibrary::EnjuItem)
Item.include(EnjuInventory::EnjuItem)
Profile.include(EnjuCirculation::EnjuProfile)
UserGroup.include(EnjuCirculation::EnjuUserGroup)

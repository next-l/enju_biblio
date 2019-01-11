class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  include EnjuSeed::EnjuUser
  include EnjuMessage::EnjuUser
end

CarrierType.include(EnjuCirculation::EnjuCarrierType)
Manifestation.include(EnjuSubject::EnjuManifestation)
Manifestation.include(EnjuNdl::EnjuManifestation)
Manifestation.include(EnjuNii::EnjuManifestation)
Manifestation.include(EnjuLoc::EnjuManifestation)
Manifestation.include(EnjuCirculation::EnjuManifestation)
Item.include(EnjuLibrary::EnjuItem)
Item.include(EnjuCirculation::EnjuItem)
User.include(EnjuCirculation::EnjuUser)
UserGroup.include(EnjuCirculation::EnjuUserGroup)

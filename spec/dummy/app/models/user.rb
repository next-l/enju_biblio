class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  include EnjuSeed::EnjuUser
  include EnjuMessage::EnjuUser
  include EnjuBookmark::EnjuUser
end

Manifestation.include(EnjuSubject::EnjuManifestation)
Manifestation.include(EnjuNdl::EnjuManifestation)
#Manifestation.include(EnjuLoc::EnjuManifestation)
Manifestation.include(EnjuBookmark::EnjuManifestation)
Manifestation.include(EnjuManifestationViewer::EnjuManifestation)
Item.include(EnjuLibrary::EnjuItem)
User.include(EnjuBiblio::EnjuUser)

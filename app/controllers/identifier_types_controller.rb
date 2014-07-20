class IdentifierTypesController < ApplicationController
  before_action :set_identifier_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /identifier_types
  def index
    authorize IdentifierType
    @identifier_types = policy_scope(IdentifierType).order(:position)
  end

  # GET /identifier_types/1
  def show
  end

  # GET /identifier_types/new
  def new
    @identifier_type = IdentifierType.new
    authorize @identifier_type
  end

  # GET /identifier_types/1/edit
  def edit
  end

  # POST /identifier_types
  def create
    @identifier_type = IdentifierType.new(identifier_type_params)
    authorize @identifier_type

    if @identifier_type.save
      redirect_to @identifier_type, notice:  t('controller.successfully_created', :model => t('activerecord.models.identifier_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /identifier_types/1
  def update
    if params[:move]
      move_position(@identifier_type, params[:move])
      return
    end
    if @identifier_type.update(identifier_type_params)
      redirect_to @identifier_type, notice:  t('controller.successfully_updated', :model => t('activerecord.models.identifier_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /identifier_types/1
  def destroy
    @identifier_type.destroy
    redirect_to identifier_types_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.identifier_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_identifier_type
      @identifier_type = IdentifierType.find(params[:id])
      authorize @identifier_type
    end

    # Only allow a trusted parameter "white list" through.
    def identifier_type_params
      params.require(:identifier_type).permit(:name, :display_name, :note)
    end
end

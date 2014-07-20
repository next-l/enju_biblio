class ContentTypesController < ApplicationController
  before_action :set_content_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /content_types
  def index
    authorize ContentType
    @content_types = policy_scope(ContentType).order(:position)
  end

  # GET /content_types/1
  def show
  end

  # GET /content_types/new
  def new
    @content_type = ContentType.new
    authorize @content_type
  end

  # GET /content_types/1/edit
  def edit
  end

  # POST /content_types
  def create
    @content_type = ContentType.new(content_type_params)
    authorize @content_type

    if @content_type.save
      redirect_to @content_type, notice:  t('controller.successfully_created', :model => t('activerecord.models.content_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /content_types/1
  def update
    if params[:move]
      move_position(@content_type, params[:move])
      return
    end
    if @content_type.update(content_type_params)
      redirect_to @content_type, notice:  t('controller.successfully_updated', :model => t('activerecord.models.content_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /content_types/1
  def destroy
    @content_type.destroy
    redirect_to content_types_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.content_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content_type
      @content_type = ContentType.find(params[:id])
      authorize @content_type
    end

    # Only allow a trusted parameter "white list" through.
    def content_type_params
      params.require(:content_type).permit(:name, :display_name, :note)
    end
end

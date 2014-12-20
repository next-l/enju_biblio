class ContentTypesController < ApplicationController
  load_and_authorize_resource
  # GET /content_types
  # GET /content_types.json
  def index
    @content_types = ContentType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @content_types }
    end
  end

  # GET /content_types/1
  # GET /content_types/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content_type }
    end
  end

  # GET /content_types/new
  # GET /content_types/new.json
  def new
    @content_type = ContentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @content_type }
    end
  end

  # GET /content_types/1/edit
  def edit
  end

  # POST /content_types
  # POST /content_types.json
  def create
    @content_type = ContentType.new(params[:content_type])

    respond_to do |format|
      if @content_type.save
        format.html { redirect_to @content_type, notice: t('controller.successfully_created', model: t('activerecord.models.content_type')) }
        format.json { render json: @content_type, status: :created, location: @content_type }
      else
        format.html { render action: "new" }
        format.json { render json: @content_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /content_types/1
  # PUT /content_types/1.json
  def update
    if params[:move]
      move_position(@content_type, params[:move])
      return
    end

    respond_to do |format|
      if @content_type.update_attributes(params[:content_type])
        format.html { redirect_to @content_type, notice: t('controller.successfully_updated', model: t('activerecord.models.content_type')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @content_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /content_types/1
  # DELETE /content_types/1.json
  def destroy
    @content_type.destroy

    respond_to do |format|
      format.html { redirect_to content_types_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.content_type')) }
      format.json { head :no_content }
    end
  end

  private
  def content_type_params
    params.require(:content_type).permit(:name, :display_name, :note)
  end
end

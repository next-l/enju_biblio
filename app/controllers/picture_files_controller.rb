class PictureFilesController < ApplicationController
  before_action :set_picture_file, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  before_action :get_attachable, :only => [:index, :new]

  # GET /picture_files
  # GET /picture_files.json
  def index
    authorize PictureFile
    if @attachable
      @picture_files = @attachable.picture_files.attached.page(params[:page])
    else
      @picture_files = PictureFile.attached.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @picture_files }
    end
  end

  # GET /picture_files/1
  # GET /picture_files/1.json
  def show
    case params[:size]
    when 'original'
      size = 'original'
    when 'thumb'
      size = 'thumb'
    else
      size = 'medium'
    end

    if @picture_file.picture.path
      if Setting.uploaded_file.storage == :s3
        file = open(@picture_file.picture.expiring_url).read.force_encoding('UTF-8')
      else
        file = @picture_file.picture.path(size)
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @picture_file }
      format.html.phone {
        if params[:format] == 'download'
          render_image(file)
        end
      }
      format.download {
        render_image(file)
      }
    end
  end

  # GET /picture_files/new
  # GET /picture_files/new.json
  def new
    #raise unless @event or @manifestation or @shelf or @agent
    @picture_file = PictureFile.new
    authorize @picture_file
    unless @attachable
      redirect_to picture_files_url
      return
    end
    @picture_file.picture_attachable = @attachable

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @picture_file }
    end
  end

  # GET /picture_files/1/edit
  def edit
  end

  # POST /picture_files
  # POST /picture_files.json
  def create
    authorize PictureFile
    @picture_file = PictureFile.new(picture_file_params)

    respond_to do |format|
      if @picture_file.save
        format.html { redirect_to @picture_file, :notice => t('controller.successfully_created', :model => t('activerecord.models.picture_file')) }
        format.json { render :json => @picture_file, :status => :created, :location => @picture_file }
      else
        format.html { render :action => "new" }
        format.json { render :json => @picture_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /picture_files/1
  # PUT /picture_files/1.json
  def update
    # 並べ替え
    if params[:move]
      move_position(@picture_file, params[:move], false)
      case
      when @picture_file.picture_attachable.is_a?(Shelf)
        redirect_to shelf_picture_files_url(@picture_file.picture_attachable)
      when @picture_file.picture_attachable.is_a?(Manifestation)
        redirect_to manifestation_picture_files_url(@picture_file.picture_attachable)
      else
        redirect_to picture_files_url
      end
      return
    end

    respond_to do |format|
      if @picture_file.update_attributes(picture_file_params)
        format.html { redirect_to @picture_file, :notice => t('controller.successfully_updated', :model => t('activerecord.models.picture_file')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @picture_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /picture_files/1
  # DELETE /picture_files/1.json
  def destroy
    @picture_file.destroy

    respond_to do |format|
      if @shelf
        format.html { redirect_to shelf_picture_files_url(@shelf) }
        format.json { head :no_content }
      else
        format.html { redirect_to picture_files_url }
        format.json { head :no_content }
      end
    end
  end

  private
  def set_picture_file
    @picture_file = PictureFile.find(params[:id])
    authorize @picture_file
  end

  def get_attachable
    get_manifestation
    if @manifestation
      @attachable = @manifestation
      return
    end
    get_agent
    if @agent
      @attachable = @agent
      return
    end
    get_event
    if @event
      @attachable = @event
      return
    end
    get_shelf
    if @shelf
      @attachable = @shelf
      return
    end
  end

  def render_image(file)
    case params[:mode]
    when 'download'
      disposition = 'attachment'
    else
      disposition = 'inline'
    end

    if @picture_file.picture.path
      if Setting.uploaded_file.storage == :s3
        send_data file, :filename => File.basename(@picture_file.picture_file_name), :type => @picture_file.picture_content_type, :disposition => disposition
      else
        if File.exist?(file) and File.file?(file)
          send_file file, :filename => File.basename(@picture_file.picture_file_name), :type => @picture_file.picture_content_type, :disposition => disposition
        end
      end
    end
  end

  def picture_file_params
    params.require(:picture_file).permit(
      :picture, :picture_attachable_id, :picture_attachable_type
    )
  end
end

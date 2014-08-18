class ExtentsController < ApplicationController
  load_and_authorize_resource
  # GET /extents
  # GET /extents.json
  def index
    @extents = Extent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @extents }
    end
  end

  # GET /extents/1
  # GET /extents/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @extent }
    end
  end

  # GET /extents/new
  # GET /extents/new.json
  def new
    @extent = Extent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @extent }
    end
  end

  # GET /extents/1/edit
  def edit
  end

  # POST /extents
  # POST /extents.json
  def create
    @extent = Extent.new(params[:extent])

    respond_to do |format|
      if @extent.save
        format.html { redirect_to @extent, notice:  t('controller.successfully_created', model:  t('activerecord.models.extent')) }
        format.json { render json: @extent, status: :created, location: @extent }
      else
        format.html { render action: "new" }
        format.json { render json: @extent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /extents/1
  # PUT /extents/1.json
  def update
    if params[:move]
      move_position(@extent, params[:move])
      return
    end

    respond_to do |format|
      if @extent.update_attributes(params[:extent])
        format.html { redirect_to @extent, notice:  t('controller.successfully_updated', model:  t('activerecord.models.extent')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @extent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /extents/1
  # DELETE /extents/1.json
  def destroy
    @extent.destroy

    respond_to do |format|
      format.html { redirect_to extents_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.extent')) }
      format.json { head :no_content }
    end
  end
end

class FrequenciesController < ApplicationController
  load_and_authorize_resource
  # GET /frequencies
  # GET /frequencies.json
  def index
    @frequencies = Frequency.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @frequencies }
    end
  end

  # GET /frequencies/1
  # GET /frequencies/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @frequency }
    end
  end

  # GET /frequencies/new
  # GET /frequencies/new.json
  def new
    @frequency = Frequency.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @frequency }
    end
  end

  # GET /frequencies/1/edit
  def edit
  end

  # POST /frequencies
  # POST /frequencies.json
  def create
    @frequency = Frequency.new(params[:frequency])

    respond_to do |format|
      if @frequency.save
        format.html { redirect_to @frequency, notice:  t('controller.successfully_created', model:  t('activerecord.models.frequency')) }
        format.json { render json: @frequency, status: :created, location: @frequency }
      else
        format.html { render action: "new" }
        format.json { render json: @frequency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /frequencies/1
  # PUT /frequencies/1.json
  def update
    if params[:move]
      move_position(@frequency, params[:move])
      return
    end

    respond_to do |format|
      if @frequency.update_attributes(params[:frequency])
        format.html { redirect_to @frequency, notice:  t('controller.successfully_updated', model:  t('activerecord.models.frequency')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @frequency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frequencies/1
  # DELETE /frequencies/1.json
  def destroy
    @frequency.destroy

    respond_to do |format|
      format.html { redirect_to frequencies_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.frequency')) }
      format.json { head :no_content }
    end
  end

  private
  def frequency_params
    params.require(:frequency).permit(:name, :display_name, :note)
  end
end

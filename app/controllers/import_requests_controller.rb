class ImportRequestsController < ApplicationController
  before_action :set_import_request, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /import_requests
  # GET /import_requests.json
  def index
    authorize ImportRequest
    @import_requests = ImportRequest.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @import_requests }
    end
  end

  # GET /import_requests/1
  # GET /import_requests/1.json
  def show
  end

  # GET /import_requests/new
  # GET /import_requests/new.json
  def new
    @import_request = ImportRequest.new
    authorize @import_request
  end

  # GET /import_requests/1/edit
  def edit
  end

  # POST /import_requests
  # POST /import_requests.json
  def create
    @import_request = ImportRequest.new(import_request_params)
    authorize @import_request
    @import_request.user = current_user

    respond_to do |format|
      if @import_request.save
        @import_request.import!
        format.html {
          if @import_request.manifestation
            redirect_to @import_request.manifestation, notice: t('controller.successfully_created', model: t('activerecord.models.import_request'))
          else
            redirect_to new_import_request_url, notice: t('import_request.record_not_found')
          end
        }
        format.json { render json: @import_request, status: :created, location: @import_request }
      else
        format.html { render action: "new" }
        format.json { render json: @import_request.errors, status: :unprocessable_entity }
      end
    end
  rescue Timeout::Error
    @import_request.transition_to!(:failed)
    flash[:notice] = t('page.timed_out')
    redirect_to new_import_request_url
  end

  # PUT /import_requests/1
  # PUT /import_requests/1.json
  def update
    if @import_request.update(import_request_params)
      redirect_to @import_request, notice: t('controller.successfully_updated', model: t('activerecord.models.import_request'))
    else
      render :edit
    end
  end

  # DELETE /import_requests/1
  # DELETE /import_requests/1.json
  def destroy
    @import_request.destroy
    redirect_to import_requests_url, notice: t('controller.successfully_destroyed', model: t('activerecord.models.import_request'))
  end

  private
  def set_import_request
    @import_request = ImportRequest.find(params[:id])
    authorize @import_request
  end

  def import_request_params
    params.require(:import_request).permit(:isbn, :manifestation_id, :user_id)
  end
end

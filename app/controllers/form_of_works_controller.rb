class FormOfWorksController < ApplicationController
  load_and_authorize_resource
  # GET /form_of_works
  # GET /form_of_works.json
  def index
    @form_of_works = FormOfWork.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @form_of_works }
    end
  end

  # GET /form_of_works/1
  # GET /form_of_works/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @form_of_work }
    end
  end

  # GET /form_of_works/new
  # GET /form_of_works/new.json
  def new
    @form_of_work = FormOfWork.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @form_of_work }
    end
  end

  # GET /form_of_works/1/edit
  def edit
  end

  # POST /form_of_works
  # POST /form_of_works.json
  def create
    @form_of_work = FormOfWork.new(params[:form_of_work])

    respond_to do |format|
      if @form_of_work.save
        format.html { redirect_to @form_of_work, notice: t('controller.successfully_created', model: t('activerecord.models.form_of_work')) }
        format.json { render json: @form_of_work, status: :created, location: @form_of_work }
      else
        format.html { render action: "new" }
        format.json { render json: @form_of_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /form_of_works/1
  # PUT /form_of_works/1.json
  def update
    if params[:move]
      move_position(@form_of_work, params[:move])
      return
    end

    respond_to do |format|
      if @form_of_work.update_attributes(params[:form_of_work])
        format.html { redirect_to @form_of_work, notice: t('controller.successfully_updated', model: t('activerecord.models.form_of_work')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @form_of_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_of_works/1
  # DELETE /form_of_works/1.json
  def destroy
    @form_of_work.destroy

    respond_to do |format|
      format.html { redirect_to form_of_works_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.form_of_work')) }
      format.json { head :no_content }
    end
  end

  private
  def form_of_work_params
    params.require(:form_of_work).permit(:name, :display_name, :note)
  end
end

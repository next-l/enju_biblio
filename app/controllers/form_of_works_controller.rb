class FormOfWorksController < ApplicationController
  before_action :set_form_of_work, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /form_of_works
  def index
    authorize FormOfWork
    @form_of_works = policy_scope(FormOfWork).order(:position)
  end

  # GET /form_of_works/1
  def show
  end

  # GET /form_of_works/new
  def new
    @form_of_work = FormOfWork.new
    authorize @form_of_work
  end

  # GET /form_of_works/1/edit
  def edit
  end

  # POST /form_of_works
  def create
    @form_of_work = FormOfWork.new(form_of_work_params)
    authorize @form_of_work

    if @form_of_work.save
      redirect_to @form_of_work, notice:  t('controller.successfully_created', :model => t('activerecord.models.form_of_work'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /form_of_works/1
  def update
    if params[:move]
      move_position(@form_of_work, params[:move])
      return
    end
    if @form_of_work.update(form_of_work_params)
      redirect_to @form_of_work, notice:  t('controller.successfully_updated', :model => t('activerecord.models.form_of_work'))
    else
      render action: 'edit'
    end
  end

  # DELETE /form_of_works/1
  def destroy
    @form_of_work.destroy
    redirect_to form_of_works_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.form_of_work'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_of_work
      @form_of_work = FormOfWork.find(params[:id])
      authorize @form_of_work
    end

    # Only allow a trusted parameter "white list" through.
    def form_of_work_params
      params.require(:form_of_work).permit(:name, :display_name, :note)
    end
end

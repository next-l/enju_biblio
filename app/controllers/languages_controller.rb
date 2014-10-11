class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /languages
  def index
    authorize Language
    @languages = policy_scope(Language).page(params[:page])
  end

  # GET /languages/1
  def show
  end

  # GET /languages/new
  def new
    @language = Language.new
    authorize @language
  end

  # GET /languages/1/edit
  def edit
  end

  # POST /languages
  def create
    @language = Language.new(language_params)
    authorize @language

    if @language.save
      redirect_to @language, notice:  t('controller.successfully_created', model: t('activerecord.models.language'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /languages/1
  def update
    if params[:move]
      move_position(@language, params[:move])
      return
    end

    if @language.update(language_params)
      redirect_to @language, notice:  t('controller.successfully_updated', model: t('activerecord.models.language'))
    else
      render action: 'edit'
    end
  end

  # DELETE /languages/1
  def destroy
    @language.destroy
    redirect_to languages_url, notice: t('controller.successfully_destroyed', model: t('activerecord.models.language'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language
      @language = Language.find(params[:id])
      authorize @language
    end

    # Only allow a trusted parameter "white list" through.
    def language_params
      params.require(:language).permit(
        :name, :native_name, :display_name, :iso_639_1, :iso_639_2, :iso_639_3,
        :note
      )
    end
end

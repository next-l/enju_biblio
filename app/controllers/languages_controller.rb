# == Schema Information
#
# Table name: languages
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  native_name  :string
#  display_name :text
#  iso_639_1    :string
#  iso_639_2    :string
#  iso_639_3    :string
#  note         :text
#  position     :integer
#

class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]
  before_action :check_policy, only: [:index, :new, :create]

  # GET /languages
  # GET /languages.json
  def index
    @languages = Language.order(:position).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @languages }
    end
  end

  # GET /languages/1
  # GET /languages/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @language }
    end
  end

  # GET /languages/new
  # GET /languages/new.json
  def new
    @language = Language.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @language }
    end
  end

  # GET /languages/1/edit
  def edit
  end

  # POST /languages
  # POST /languages.json
  def create
    @language = Language.new(language_params)

    respond_to do |format|
      if @language.save
        format.html { redirect_to @language, notice: t('controller.successfully_created', model: t('activerecord.models.language')) }
        format.json { render json: @language, status: :created, location: @language }
      else
        format.html { render action: "new" }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /languages/1
  # PUT /languages/1.json
  def update
    if params[:move]
      move_position(@language, params[:move])
      return
    end

    respond_to do |format|
      if @language.update_attributes(language_params)
        format.html { redirect_to @language, notice: t('controller.successfully_updated', model: t('activerecord.models.language')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /languages/1
  # DELETE /languages/1.json
  def destroy
    @language.destroy

    respond_to do |format|
      format.html { redirect_to languages_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.language')) }
      format.json { head :no_content }
    end
  end

  private
  def set_language
    @language = Language.find(params[:id])
    authorize @language
    access_denied unless LibraryGroup.site_config.network_access_allowed?(request.ip)
  end

  def check_policy
    authorize Language
  end

  def language_params
    params.require(:language).permit(
      :name, :native_name, :display_name, :iso_639_1, :iso_639_2, :iso_639_3,
      :note
    )
  end
end

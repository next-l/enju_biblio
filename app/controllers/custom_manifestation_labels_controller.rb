class CustomManifestationLabelsController < ApplicationController
  before_action :set_custom_manifestation_label, only: [:show, :edit, :update, :destroy]
  before_action :check_policy, only: [:index, :new, :create]

  # GET /custom_manifestation_labels
  def index
    @custom_manifestation_labels = CustomManifestationLabel.all
  end

  # GET /custom_manifestation_labels/1
  def show
  end

  # GET /custom_manifestation_labels/new
  def new
    @custom_manifestation_label = CustomManifestationLabel.new
  end

  # GET /custom_manifestation_labels/1/edit
  def edit
  end

  # POST /custom_manifestation_labels
  def create
    @custom_manifestation_label = CustomManifestationLabel.new(custom_manifestation_label_params)

    if @custom_manifestation_label.save
      redirect_to @custom_manifestation_label, notice: 'Custom manifestation label was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /custom_manifestation_labels/1
  def update
    if @custom_manifestation_label.update(custom_manifestation_label_params)
      redirect_to @custom_manifestation_label, notice: 'Custom manifestation label was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /custom_manifestation_labels/1
  def destroy
    @custom_manifestation_label.destroy
    redirect_to custom_manifestation_labels_url, notice: 'Custom manifestation label was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_manifestation_label
      @custom_manifestation_label = CustomManifestationLabel.find(params[:id])
      authorize @custom_manifestation_label
    end

    def check_policy
      authorize CustomManifestationLabel
    end

    # Only allow a trusted parameter "white list" through.
    def custom_manifestation_label_params
      params.require(:custom_manifestation_label).permit(:library_group_id, :label)
    end
end

class CustomItemLabelsController < ApplicationController
  before_action :set_custom_item_label, only: [:show, :edit, :update, :destroy]
  before_action :check_policy, only: [:index, :new, :create]

  # GET /custom_item_labels
  def index
    @custom_item_labels = CustomItemLabel.all
  end

  # GET /custom_item_labels/1
  def show
  end

  # GET /custom_item_labels/new
  def new
    @custom_item_label = CustomItemLabel.new
  end

  # GET /custom_item_labels/1/edit
  def edit
  end

  # POST /custom_item_labels
  def create
    @custom_item_label = CustomItemLabel.new(custom_item_label_params)

    if @custom_item_label.save
      redirect_to @custom_item_label, notice: 'Custom item label was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /custom_item_labels/1
  def update
    if @custom_item_label.update(custom_item_label_params)
      redirect_to @custom_item_label, notice: 'Custom item label was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /custom_item_labels/1
  def destroy
    @custom_item_label.destroy
    redirect_to custom_item_labels_url, notice: 'Custom item label was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_custom_item_label
      @custom_item_label = CustomItemLabel.find(params[:id])
      authorize @custom_item_label
    end

    def check_policy
      authorize CustomItemLabel
    end

    # Only allow a trusted parameter "white list" through.
    def custom_item_label_params
      params.require(:custom_item_label).permit(:library_group_id, :label)
    end
end

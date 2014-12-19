class RealizesController < ApplicationController
  load_and_authorize_resource
  before_filter :get_agent, :get_expression
  before_filter :prepare_options, only: [:new, :edit]
  after_filter :solr_commit, only: [:create, :update, :destroy]

  # GET /realizes
  # GET /realizes.json
  def index
    case
    when @agent
      @realizes = @agent.realizes.order('realizes.position').page(params[:page])
    when @expression
      @realizes = @expression.realizes.order('realizes.position').page(params[:page])
    else
      @realizes = Realize.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @realizes }
    end
  end

  # GET /realizes/1
  # GET /realizes/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @realize }
    end
  end

  # GET /realizes/new
  def new
    if @expression && @agent.blank?
      redirect_to expression_agents_url(@expression)
      return
    elsif @agent && @expression.blank?
      redirect_to agent_expressions_url(@agent)
      return
    else
      @realize = Realize.new
      @realize.expression = @expression
      @realize.agent = @agent
    end
  end

  # GET /realizes/1/edit
  def edit
  end

  # POST /realizes
  # POST /realizes.json
  def create
    @realize = Realize.new(params[:realize])

    respond_to do |format|
      if @realize.save
        format.html { redirect_to @realize, notice: t('controller.successfully_created', model: t('activerecord.models.realize')) }
        format.json { render json: @realize, status: :created, location: @realize }
      else
        prepare_options
        format.html { render action: "new" }
        format.json { render json: @realize.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /realizes/1
  # PUT /realizes/1.json
  def update
    # 並べ替え
    if @expression && params[:move]
      move_position(@realize, params[:move], false)
      redirect_to realizes_url(expression_id: @realize.expression_id)
      return
    end

    respond_to do |format|
      if @realize.update_attributes(params[:realize])
        format.html { redirect_to @realize, notice: t('controller.successfully_updated', model: t('activerecord.models.realize')) }
        format.json { head :no_content }
      else
        prepare_options
        format.html { render action: "edit" }
        format.json { render json: @realize.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /realizes/1
  # DELETE /realizes/1.json
  def destroy
    @realize.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = t('controller.successfully_deleted', model: t('activerecord.models.realize'))
        case
        when @expression
          redirect_to expression_agents_url(@expression)
        when @agent
          redirect_to agent_expressions_url(@agent)
        else
          redirect_to realizes_url
        end
      }
      format.json { head :no_content }
    end
  end

  private
  def realize_params
    params.require(:realize).permit(
      :agent_id, :expression_id, :realize_type_id, :position
    )
  end

  def prepare_options
    @realize_types = RealizeType.all
  end
end

require "enju_biblio/engine"
require "enju_biblio/biblio_helper"

module EnjuBiblio
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def enju_biblio
      include EnjuBiblio::InstanceMethods
    end
  end

  module InstanceMethods
    private

    def get_work
      @work = Manifestation.find(params[:work_id]) if params[:work_id]
      authorize @work, :show? if @work
    end

    def get_expression
      @expression = Manifestation.find(params[:expression_id]) if params[:expression_id]
      authorize @expression, :show? if @expression
    end

    def get_manifestation
      @manifestation = Manifestation.find(params[:manifestation_id]) if params[:manifestation_id]
      authorize @manifestation, :show? if @manifestation
    end

    def get_item
      @item = Item.find(params[:item_id]) if params[:item_id]
      authorize @item, :show? if @item
    end

    def get_carrier_type
      @carrier_type = CarrierType.find(params[:carrier_type_id]) if params[:carrier_type_id]
    end

    def get_agent
      @agent = Agent.find(params[:agent_id]) if params[:agent_id]
      authorize @agent, :show? if @agent
    end

    def get_series_statement
      @series_statement = SeriesStatement.find(params[:series_statement_id]) if params[:series_statement_id]
      authorize @series_statement, :show? if @series_statement
    end

    def get_basket
      @basket = Basket.find(params[:basket_id]) if params[:basket_id]
      authorize @basket, :show? if @basket
    end

    def get_agent_merge_list
      @agent_merge_list = AgentMergeList.find(params[:agent_merge_list_id]) if params[:agent_merge_list_id]
    end

    def get_series_statement_merge_list
      @series_statement_merge_list = SeriesStatementMergeList.find(params[:series_statement_merge_list_id]) if params[:series_statement_merge_list_id]
    end
  end
end

ActionController::Base.send(:include, EnjuBiblio)

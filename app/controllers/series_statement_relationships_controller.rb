class SeriesStatementRelationshipsController < InheritedResources::Base
  load_and_authorize_resource

  def new
    @series_statement_relationship = SeriesStatementRelationship.new(params[:series_statement_relationship])
    @series_statement_relationship.parent = SeriesStatement.find(params[:parent_id]) rescue nil
    @series_statement_relationship.child = SeriesStatement.find(params[:child_id]) rescue nil
  end
end

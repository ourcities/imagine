#coding: utf-8

class IdeasController < InheritedResources::Base
  belongs_to :problem
  before_filter only: [:show] { @contribution = Contribution.new }
  before_filter only: [:create] { params[:idea][:user_id] = current_user.id }
  authorize_resource

  respond_to :json, only: [:index]

  def preview
    @idea = Idea.new(params[:idea])
    render partial: "description"
  end

  def create
    create! do |format|
      format.html { redirect_to problem_idea_path(@problem, @idea), flash: {new_idea: true} }
    end
  end

  def destroy
    destroy!(notice: "A ideia nem era tão boa assim") { problem_path(@problem) }
  end
end

class Api::TodosController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @todos = Todo.all.where(user_id: params[:user_id])
    render formats: :json
  end
  def create
    @todo = Todo.new(user_id: params[:user_id], title: params[:title], body: params[:body])
    @todo.save
    render formats: :json
  end
  def destroy
    @todo = Todo.find(params[:id])
    @todo.delete
    render formats: :json
  end
  def show
    @todo = Todo.find(params[:id])
  end
  def update
    @todo = Todo.find(params[:id])
  end
end

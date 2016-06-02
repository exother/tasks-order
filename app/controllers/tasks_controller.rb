class TasksController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def order
    structure = params[:structure]

    begin
      tasks = Task.create_from_string(structure)
      order = Task.order(tasks)
      output = Task.print_collection(order)

      render json: {order: output, status: 'ok'}, status: 200
    rescue => e
      render json: {error: e.message, status: 'error'}, status: 200
    end
  end

end

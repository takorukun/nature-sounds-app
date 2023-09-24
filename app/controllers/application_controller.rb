class ApplicationController < ActionController::Base
  def db_test
    result = ActiveRecord::Base.connection.execute("SELECT 1 AS test")
    render json: { status: 'success', result: result.first }
  rescue => e
    Rails.logger.error("DB Test failed: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    render json: { status: 'error', message: 'Database connection test failed.' }, status: 500
  end
end

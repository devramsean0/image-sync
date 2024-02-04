class CleanupSessionsJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 30.seconds, attempts: 3
  def perform(*args)
    puts "Cleaning up User Sessions"
    
    # Clean up Unauthenticated Sessions
    unathenticatedSessions = UserSession.where("updated_at < ?", 1.day.ago).destroy_all
    puts "Cleaned up #{unathenticatedSessions.count} unauthenticated sessions"
    oldSessions = UserSession.where("updated_at < ?", 1.month.ago).destroy_all
    puts "Cleaned up #{oldSessions.count} old sessions"

    puts "Cleaned up #{unathenticatedSessions.count + oldSessions.count} sessions"
  end
end

# frozen_string_literal: true

class RecommendationService # rubocop:disable Style/Documentation
  def call(user)
    if Flipper.enabled?(:new_recommendation_engine, user)
      Rails.logger.info("[FLAG] new_recommendation_engine=ENABLED user_id=#{user.id}")
      run_new_engine(user)
    else
      Rails.logger.info("[FLAG] new_recommendation_engine=DISABLED user_id=#{user.id}")
      run_legacy_engine(user)
    end
  end

  private

  def run_new_engine(user)
    Rails.logger.info("[ENGINE] Running NEW recommendation engine for user_id=#{user.id}")
    # Logic baru...
    { engine: :new, recommendations: [] }
  end

  def run_legacy_engine(user)
    Rails.logger.info("[ENGINE] Running LEGACY recommendation engine for user_id=#{user.id}")
    # Logic lama...
    { engine: :legacy, recommendations: [] }
  end
end

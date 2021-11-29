class CreateGameworldJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  good_job_control_concurrency_with(
    total_limit: 1,
    enqueue_limit: 1,
    perform_limit: 1
  )

  after_perform :set_other_gameworlds_to_inactive
  after_perform :publish_gameworld_created_event

  def perform(gameworld_id, player_amount)
    fetch_gameworld(gameworld_id)
    GameworldBuilder.create_regular_gameworld(@gameworld, player_amount)
  end

  private

  def fetch_gameworld(gameworld_id)
    @gameworld = Gameworld.find(gameworld_id)
  end

  def set_other_gameworlds_to_inactive
    @gameworld.activate
  end

  def publish_gameworld_created_event
    @gameworld.publish_gameworld_created_event
  end
end

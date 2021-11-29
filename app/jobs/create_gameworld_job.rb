class CreateGameworldJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

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

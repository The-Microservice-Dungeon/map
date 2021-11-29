class CreateGameworldMovementDifficultyJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  def perform(gameworld_id)
    fetch_gameworld(gameworld_id)
    add_movement_difficulty
  end

  private

  def fetch_gameworld(gameworld_id)
    @gameworld = Gameworld.find(gameworld_id)
  end

  def add_movement_difficulty
    @gameworld.planets.each do |p|
      p.movement_difficulty = 2 if p.mid_map?
      p.movement_difficulty = 3 if p.inner_map?
      p.save!
    end
  end
end

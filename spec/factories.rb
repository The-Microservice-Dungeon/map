FactoryBot.define do
  factory :gameworld do
    status { 'active' }
  end

  factory :resource_type do
    difficulty { 0 }
    name { 'coal' }
  end

  factory :planet do
    movement_difficulty { 0 }
    recharge_multiplicator { 0 }
    planet_type { 'default' }
    x { 0 }
    y { 0 }
    gameworld

    trait :taken do
      taken_at { DateTime.current }
    end

    trait :spawn do
      planet_type { 'spawn' }
    end

    trait :spacestation do
      planet_type { 'spacestation' }
    end

    factory :spawn_planet, traits: %i[spawn taken]
    factory :spacestation_planet, traits: [:spacestation]
  end
end
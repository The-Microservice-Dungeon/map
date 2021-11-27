FactoryBot.define do
  factory :exploration do
    planet
    transaction_id { '' }
  end

  factory :replenishment do
    planet
    resource
  end

  factory :spawn_creation do
    planet
  end

  factory :spacestation_creation do
    planet
  end

  factory :mining do
    planet
    amount_requested { 300 }
    resource
  end

  factory :resource do
    max_amount { 1000 }
    current_amount { 400 }
    planet
    resource_type { 'coal' }
  end

  factory :gameworld do
    status { 'active' }
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

    factory :planet_with_resources do
      transient do
        resource_count { 1 }
      end

      after(:create) do |planet, _evaluator|
        create(:resource, planet: planet)

        planet.reload
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Map Service API',
        description: 'This is the REST documentation for the Map Service',
        version: Rails.application.config.version
      },
      components: {
        schemas: {
          errors_object: {
            type: 'object',
            properties: {
              status: { type: 'integer', example: 404 },
              error: { type: 'string', example: 'Not Found' },
              exception: { type: 'string', example: "Couldn't find Gameworld with 'id'=1" }
            }
          },
          gameworld: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid },
              spacestation_ids: { type: :array, items: { type: :string, format: :uuid } },
              status: { type: :string, enum: %w[active inactive] },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          },
          planet: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid },
              movement_difficulty: { type: :integer },
              recharge_multiplicator: { type: :integer },
              gameworld_id: { type: :string, format: :uuid },
              planet_type: { type: :string, enum: %w[default spacestation] },
              neighbours: { type: :array, items: { type: :object, properties: {
                planet_id: { type: :string, format: :uuid },
                movement_difficulty: { type: :integer },
                direction: { type: :string, enum: %w[north east south west] }
              } } },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              resource: { oneOf: [{ '$ref' => '#/components/schemas/resource' }, { type: nil }] }
            }
          },
          resource: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid },
              planet_id: { type: :string, format: :uuid },
              max_amount: { type: :integer },
              current_amount: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              resource_type: { type: :string, enum: %w[coal iron gem gold platin] }
            }
          },
          mining: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid },
              amount_requested: { type: :integer },
              amount_mined: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end

# frozen_string_literal: true

class AddVersions < ActiveRecord::Migration[6.1]
  def self.up
    execute 'CREATE SEQUENCE minings_version_seq START 1'
    execute 'CREATE SEQUENCE replenishments_version_seq START 1'
    execute 'CREATE SEQUENCE explorations_version_seq START 1'
    execute 'CREATE SEQUENCE spawn_creations_version_seq START 1'
    execute 'CREATE SEQUENCE spacestation_creations_version_seq START 1'

    execute "ALTER TABLE minings ALTER COLUMN version SET DEFAULT NEXTVAL('minings_version_seq')"
    execute "ALTER TABLE replenishments ALTER COLUMN version SET DEFAULT NEXTVAL('replenishments_version_seq')"
    execute "ALTER TABLE explorations ALTER COLUMN version SET DEFAULT NEXTVAL('explorations_version_seq')"
    execute "ALTER TABLE spawn_creations ALTER COLUMN version SET DEFAULT NEXTVAL('spawn_creations_version_seq')"
    execute "ALTER TABLE spacestation_creations ALTER COLUMN version SET DEFAULT NEXTVAL('spacestation_creations_version_seq')"
  end

  def self.down
    execute 'DROP SEQUENCE minings_version_seq'
    execute 'DROP SEQUENCE replenishments_version_seq'
    execute 'DROP SEQUENCE explorations_version_seq'
    execute 'DROP SEQUENCE spawn_creations_version_seq'
    execute 'DROP SEQUENCE spacestation_creations_version_seq'
  end
end

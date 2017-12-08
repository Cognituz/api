require 'fileutils'

LOCK_FILE = File.expand_path("./.setuplock")

module Setup
  def self.perform
    locking do
      %w[
        db:create
        db:migrate
        db:seed
        assets:clean
        assets:precompile
      ].each { |t| Rake::Task[t].invoke }
    end
  end

  private

  def self.locking(&block)
    raise "LOCKED. rm #{LOCK_FILE}" if locked?
    lock
    yield
  ensure
    unlock
  end

  def self.locked?() File.exists?(File.expand_path(LOCK_FILE)) end
  def self.lock()    FileUtils.touch(LOCK_FILE) end
  def self.unlock()  File.delete(LOCK_FILE) end
end

desc "Setup environment for productive usage"
task setup: :environment do
  Setup.perform
end

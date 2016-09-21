namespace :shared_configs do
  desc 'Pull the latest from the shared configs directory and symlink the files'
  task :update do
    invoke 'shared_configs:pull'
    invoke 'shared_configs:symlink'
  end

  desc 'Pulls the latest from the shared configs directory'
  task :pull do
    on roles(:app) do
      if test("[ -d #{shared_configs_path} ]")
        execute <<-COMMAND
          cd #{shared_configs_path}
          git pull
        COMMAND
      else
        puts "Unable to pull shared configs. No shared configs located at #{shared_configs_path}."
      end
    end
  end

  desc 'Symlinks the shared configs directory into the capistrano shared directory'
  task :symlink do
    on roles(:app) do
      if test("[ -d #{shared_configs_path} ]")
        execute <<-COMMAND
          cd #{shared_configs_path}
          cp -rlf * ../
        COMMAND
      else
        puts "Unable to symlink shared configs. No shared configs located at #{shared_configs_path}."
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :shared_configs_path, -> { shared_path.join('repo_configs') }
  end
end

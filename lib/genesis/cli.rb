require 'thor'
require 'genesis/commands'

module Genesis
  class Cli < Thor
    include Commands

    desc 'refresh', 'Reconcile state with the real-world infrastructure'
    def refresh
      system refresh_command
    end

    desc 'plan', 'Output an execution plan'
    def plan
      system plan_command
    end

    desc 'apply', 'Apply infrastructure changes to match plan'
    def apply
      confirmed = if @prompt
        message = 'Are you sure you want to apply changes? (y/n)'
        yes?(message, :red)
      else
        true
      end

      system apply_command if confirmed
    end

    desc 'show', 'Output contents of the state file'
    def show
      system show_command
    end

    desc 'destroy', 'Destroy infrastructure Terraform knows about'
    def destroy
      plan_created = system destroy_plan_command
      exit(1) unless plan_created

      confirmed = if @prompt
        yes?('Are you sure you want to destroy infrastructure? (y/n)', :red)
      else
        true
      end

      system apply_plan_command if confirmed
      File.delete(plan_file) if File.exist?(plan_file)
    end

    option :prompt, {
      type: :boolean,
      default: true,
      desc: 'Prompt before executing dangerous commands'
    }
    option :terraform_dir, {
      default: File.join(Dir.pwd, 'terraform'),
      desc: 'Directory where terraform files can be found'
    }
    option :vars, {
      required: true,
      type: :hash,
      default: {},
      desc: "Adds additional variables for a Terraform command."
    }
    def initialize(*args)
      super

      @aws_access_key = ENV['AWS_ACCESS_KEY']
      @aws_secret_key = ENV['AWS_SECRET_KEY']
      @aws_key_pair = ENV['AWS_KEY_PAIR']
      @prompt = options[:prompt]
      @terraform_dir = options[:terraform_dir]
      @vars = options[:vars]

      validate_environment_variables
      validate_path
      validate_terraform_directory
    end

  private

    def validate_environment_variables
      # Check for required environment variables
      required_variables = %w[
        AWS_ACCESS_KEY
        AWS_SECRET_KEY
        AWS_KEY_PAIR
      ]

      required_variables.each do |variable|
        unless ENV.member? variable
          $stderr.puts "Missing required environment variable: '#{variable}'"
          exit(1)
        end
      end
    end

    def validate_path
      # Check for required executables on the system path
      required_executables = %w[terraform]

      required_executables.each do |name|
        next unless /#{name}/.match(ENV['PATH']).nil?

        message = "Missing required executable on system path: '#{name}'"
        $stderr.puts message
        exit(1)
      end
    end

    def validate_terraform_directory
      # Check that terraform directory is present
      path = File.join(@terraform_dir)

      return if Dir.exist? path

      $stderr.puts "Unable to find terraform directory: #{path}"
      exit(1)
    end

    def state_file
      File.join(@terraform_dir, 'terraform.tfstate')
    end

    def plan_file
      File.join(@terraform_dir, 'terraform.tfplan')
    end
  end
end

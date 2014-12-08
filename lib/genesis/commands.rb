require 'thor'

module Genesis
  module Commands
    def destroy_plan_command
      command = []
      command << 'terraform plan'
      command << variables
      command.flatten!
      command << '-refresh=true'
      command << '-destroy'
      command << "-state=#{state_file}"
      command << "-out=#{plan_file}"
      command << "#{@terraform_dir}"

      command.join(' ')
    end

    def apply_command
      command = []
      command << 'terraform apply'
      command << variables
      command.flatten!
      command << '-refresh=true'
      command << "-state=#{state_file}"
      command << "#{@terraform_dir}"

      command.join(' ')
    end

    def refresh_command
      command = []
      command << 'terraform refresh'
      command << variables
      command.flatten!
      command << "-state=#{state_file}"
      command << "#{@terraform_dir}"

      command.join(' ')
    end

    def plan_command
      command = []
      command << 'terraform plan'
      command << variables
      command.flatten!
      command << '-refresh=true'
      command << "-state=#{state_file}"
      command << "#{@terraform_dir}"

      command.join(' ')
    end

    def show_command
      "terraform show #{state_file}"
    end

    def apply_plan_command
      %W[
        terraform apply
        -state=#{state_file}
        #{plan_file}
      ].join(' ')
    end

  private

    def variables
      defaults = {
        aws_access_key: @aws_access_key,
        aws_secret_key: @aws_secret_key,
        aws_key_pair: @aws_key_pair
      }

      variables = defaults.merge(@vars)

      variables.reduce([]) do |data, (name, value)|
        data << "-var \"#{name}=#{value}\""
      end
    end
  end
end

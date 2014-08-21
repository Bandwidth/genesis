require 'thor'

module Genesis
  module Commands
    def destroy_plan_command
      %W[
        terraform plan
        -var "aws_access_key=#{@aws_access_key}"
        -var "aws_secret_key=#{@aws_secret_key}"
        -var "aws_key_pair=#{@aws_key_pair}"
        -refresh=true
        -destroy
        -state=#{state_file}
        -out=#{plan_file}
        #{terraform_dir}
      ].join(' ')
    end

    def apply_plan_command
      %W[
        terraform apply
        -state=#{state_file}
        #{plan_file}
      ].join(' ')
    end

    def apply_command
      %W[
        terraform apply
        -var "aws_access_key=#{@aws_access_key}"
        -var "aws_secret_key=#{@aws_secret_key}"
        -var "aws_key_pair=#{@aws_key_pair}"
        -refresh=true
        -state=#{state_file}
        #{terraform_dir}
      ].join(' ')
    end

    def refresh_command
      %W[
        terraform refresh
        -var "aws_access_key=#{@aws_access_key}"
        -var "aws_secret_key=#{@aws_secret_key}"
        -var "aws_key_pair=#{@aws_key_pair}"
        -state=#{state_file}
        #{terraform_dir}
      ].join(' ')
    end

    def plan_command
      %W[
        terraform plan
        -var "aws_access_key=#{@aws_access_key}"
        -var "aws_secret_key=#{@aws_secret_key}"
        -var "aws_key_pair=#{@aws_key_pair}"
        -refresh=true
        -state=#{state_file}
        #{terraform_dir}
      ].join(' ')
    end

    def show_command
      "terraform show #{state_file}"
    end
  end
end

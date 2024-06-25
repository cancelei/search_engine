class AddProviderJobIdToGoodJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :good_jobs, :provider_job_id, :string
    add_index :good_jobs, :provider_job_id
  end
end

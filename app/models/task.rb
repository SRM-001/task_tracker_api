class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum status: { to_do: 0, in_progress: 1, completed: 2 }
  enum priority: { low: 0, medium: 1, high: 2 }

  validates :title, :status, :due_date, :priority, presence: true
  validate :due_date_before_project_end

  private

  def due_date_before_project_end
    if project && due_date > project.end_date
      errors.add(:due_date, "must be before project's end date")
    end
  end
end

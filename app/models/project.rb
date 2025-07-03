class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, :desc, :start_date, :end_date, presence: true
  validate :start_date_before_end_date

  private

  def start_date_before_end_date
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:start_date, "must be before end date")
    end
  end
end

# frozen_string_literal: true

class User < ActiveRecord::Base
  # NOTE: added this to solve migration error missing Devise Model
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable # , :trackable,
  include DeviseTokenAuth::Concerns::User

  # ActiveStorage
  has_one_attached :gov_id_document
  validate :acceptable_document

  # Tasks
  has_many :tasks, dependent: :destroy
  has_many :conversations, dependent: :destroy # TODO: dependent delay destroy
  has_many :messages, dependent: :destroy # TODO: dependent delay destroy
  # has_many :messages, through: :conversations
  # has_many :tasks, through: :conversations

  # User validations
  validates :email, length: { in: 3..64, message: "should have a valid format and be less than 64 characters" }
  validates :first_name, presence: true, length: { in: 1..64, message: "should be less than 64 characters" }
  validates :last_name, presence: true, length: { in: 1..63, message: "should be less than 64 characters" }
  validates :default_lat, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90, message: "Out of Latitude Range" }
  validates :default_lng, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180, message: "Out of Longitude Range" }

  after_initialize do |u|
    Current.default_coords = u

  end

  # Add gov_id_document file uploads valiations
  def acceptable_document
    return unless gov_id_document.attached?
    unless gov_id_document.byte_size <= 10.megabyte
      errors.add(:gov_id_document, "File is too big")
    end

    acceptable_documents = ["application/pdf", "image/pdf", "image/png", "image/jpeg"]
    unless acceptable_documents.include?(gov_id_document.content_type)
      errors.add(:gov_id_document, "Must be a .pdf, .png or .jpeg filetype")
    end
  end


end

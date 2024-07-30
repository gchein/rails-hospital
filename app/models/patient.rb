class Patient < ApplicationRecord
  belongs_to :room, optional: true
end

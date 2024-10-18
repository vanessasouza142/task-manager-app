class Task < ApplicationRecord  

  enum status: {  
    pending: 'pending',
    in_progress: 'in_progress',
    completed: 'completed',
    failure: 'failure',
  }, _default: 'pending', _prefix: true

  validates_presence_of :url
  
end

class NotifyUserMailer < ApplicationMailer
  default from: 'notifications@stridecatcher.com'

  def shoe_mileage_reached(shoe)
    @shoe = shoe
    @user = @shoe.user
    @message = "Your #{@shoe.name} has #{@shoe.distance_in_miles} miles on it."

    mail to: @user.email, subject: "Time to change your shoes!"
  end
end

class ReceiveTextController < ApplicationController
  def index
    # let's pretend that we've mapped this action to
    # http://localhost:3000/sms in the routes.rb file

    twiml = "<Response>
      <Sms>Thanks for your message!</Sms>
    </Response>"

    render plain: twiml
  end
end

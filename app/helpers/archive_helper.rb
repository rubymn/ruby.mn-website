module ArchiveHelper
  def get_replies(msg, ar)
    if(msg.children.empty?)
      ar << msg.id
    else
      msg.children.each do |c|
        get_replies(c, ar)
      end
    end
  end
end

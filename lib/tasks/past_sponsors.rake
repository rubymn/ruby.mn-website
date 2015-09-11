namespace :sponsors do
  desc "Loads all the known historic sponsors as of 2015.09.11"
  task :clean_and_load_all => :environment do 
    Sponsor.destroy_all
    [
      ["harbinger-partners-small.png", "harbingerpartners.com", "harbinger-partners-large.png", "CONNECTING TOP-TIER TALENT WITH ACCOMPLISHED COMPANIES"],
      ["the-garage.png", "thegarage.us", "the-garage.png", "The Garage seeks to build a portfolio of startup ideas that will impact the health system at-large in big, transformative ways."],
      ["valere-small.png", "valere.com", "valere-large.png", "Exceptional talent. Refreshingly personal services."],
      ["zencoder_150w.png", "zencoder.com"],
      ["Wiscota-Logo.png", "www.wiscota.com/services"],
      ["ATOMICNameWhite.png", "atomicdatacenters.com"],
      ["recursive_awesome.png", "recursiveawesome.com"],
      ["1543AD.png", "1543ad.com"],
      ["engineyard.png", "www.engineyard.com"],
      ["oneplace-logo.png", "www.oneplacehome.com"],
      ["drivetrain_150w.png", "drivetrainagency.com"],
      ["KRCLogoTransparent_143.png", "kettleriverconsulting.com"],
      ["softwareforgood.png", "softwareforgood.com"],
      ["pvue_logo_70percent.gif", "pearsonvue.com"],
      ["arux_logo.png", "aruxsoftware.com"],
      ["reach-logo.png", "www.reachlocal.com"],
    ].each do |sponsor|
      puts "Creating Past Sponsor: #{sponsor}"
      Sponsor.create!(
        logo_image_small: sponsor[0],
        contact_url: sponsor[1], 
        logo_image_large: sponsor[2],
        description: sponsor[3],
        current: false
      )
    end


    valere = Sponsor.find_by_contact_url('valere.com')
    garage = Sponsor.find_by_contact_url('thegarage.us')

    valere.current = true
    garage.current = true

    valere.save!
    garage.save!

  end

end


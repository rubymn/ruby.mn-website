namespace :sponsors do
  desc "Loads all the known historic sponsors as of 2014.01.26"
  task :clean_and_load_all => :environment do 
    Sponsor.destroy_all
    %w[
      zencoder_150w.png zencoder.com
      Wiscota-Logo.png www.wiscota.com/services
      ATOMICNameWhite.png atomicdatacenters.com
      recursive_awesome.png recursiveawesome.com
      1543AD.png 1543ad.com
      engineyard.png www.engineyard.com
      oneplace-logo.png www.oneplacehome.com
      drivetrain_150w.png drivetrainagency.com
      KRCLogoTransparent_143.png kettleriverconsulting.com
      softwareforgood.png softwareforgood.com
      pvue_logo_70percent.gif pearsonvue.com
      arux_logo.png aruxsoftware.com
      reach-logo.png www.reachlocal.com
    ].each_slice(2) do |sponsor|
      puts "Creating Past Sponsor: #{sponsor}"
      Sponsor.create!(
        logo_image_small: sponsor[0],
        contact_url: sponsor[1], 
        current: false
      )
    end

    Sponsor.create!(
      logo_image_small: 'star-collab-logo.png',
      contact_url: 'www.starcollaborative.com',
      description: 'We love to help people! More specifically, we love to connect people to jobs, and the way we manage third-party staffing is dramatically different from anything you have ever experienced. Everything about our business model - our rate structures; transparency; customizable, cloud-based back-end; and the quality of our consultants and clients - has completely disrupted the traditional staffing and direct hire placement mindset.',
      current: true
    )
  end

end


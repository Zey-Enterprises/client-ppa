# Run after building: bundle exec ruby scripts/validate.rb
require 'nokogiri'
require 'uri'
require 'digest'
root = File.expand_path('../_site', __dir__)
errors = []
routes = %w[/ /home /about /lessons /blog /blog/black-pearl-couloir /blog/my-first-trip-to-ouray /blog/why-do-i-climb /blog/willow-lake-ice-wi5]
def target(root, path)
  [File.join(root,path), File.join(root,"#{path}.html"), File.join(root,path,'index.html')].find { |f| File.file?(f) }
end
routes.each { |r| errors << "Missing route #{r}" unless target(root,r) }
files = Dir.glob("#{root}/**/*.html")
files.each do |file|
  doc = Nokogiri::HTML(File.read(file))
  errors << "Missing title #{file}" unless doc.at_css('title')
  errors << "Missing canonical #{file}" unless doc.at_css('link[rel=canonical]')
  errors << "Duplicate IDs #{file}" unless doc.css('[id]').map{|n|n['id']}.uniq.size == doc.css('[id]').size
  doc.css('[src],a[href],link[href]').each do |n|
    url = n['src'] || n['href']; next if url.nil? || url.empty?
    errors << "Remote runtime resource #{url}" if n['src'] && url.match?(/\Ahttps?:/)
    next unless url.start_with?('/') && !url.start_with?('//')
    path, hash = url.split('#', 2); next if path.empty?
    resolved = target(root,URI::DEFAULT_PARSER.unescape(path))
    errors << "Broken local reference #{url} in #{file}" unless resolved
    if resolved && hash && File.extname(resolved)=='.html'
      dest=Nokogiri::HTML(File.read(resolved));errors << "Missing anchor #{url}" unless dest.css('[id]').any?{|e|e['id']==hash}
    end
  end
  doc.css('img').each{|i| errors << "Missing alt in #{file}" if i['alt'].to_s.empty?}
end
%w[.codex docs scripts AGENTS.md Gemfile Gemfile.lock output].each{|p| errors << "Published development file #{p}" if File.exist?(File.join(root,p))}
errors << 'CNAME differs from tracked original' unless File.binread('CNAME') == IO.popen(%w[git show HEAD:CNAME], &:read)
errors << 'CNAME not copied faithfully' unless File.binread('CNAME') == File.binread(File.join(root,'CNAME'))
# Compare every paragraph, heading, caption, and image order to the immutable archive.
Dir.glob('_posts/*.html').each do |file|
  slug=File.basename(file).sub(/^\d{4}-\d{2}-\d{2}-/,'').sub(/\.html$/,'')
  ref=Nokogiri::HTML(File.read(".codex/squarespace-chasepopp.com/playwright/pages/blog/#{slug}/rendered-desktop.html"))
  ref.css('style,script').remove
  generated=Nokogiri::HTML(File.read(target(root,"/blog/#{slug}")))
  normalize=->(n){n.text.gsub(/\s+/, ' ').strip}
  expected=ref.css('.blog-item-content .sqs-html-content p,.blog-item-content .sqs-html-content h2,.blog-item-content .sqs-html-content h3,.blog-item-content .sqs-html-content h4').map(&normalize)
  actual=generated.css('.post-content .article-text p,.post-content .article-text h2,.post-content .article-text h3,.post-content .article-text h4').map(&normalize)
  errors << "Article text differs: #{slug}" unless expected == actual
  captions=ref.css('.blog-item-content figcaption').map(&normalize).reject(&:empty?)
  errors << "Captions differ: #{slug}" unless captions==generated.css('.post-content figcaption').map(&normalize)
  count=ref.css('.blog-item-content img').size
  errors << "Image count differs: #{slug}" unless count==generated.css('.post-content img').size
end
abort errors.join("\n") unless errors.empty?
puts "PASS: #{routes.size} routes; #{files.size} HTML files; local links/assets, alt text, IDs, exclusions, CNAME, and all four complete article texts/captions/image counts."

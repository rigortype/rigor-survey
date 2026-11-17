#!/usr/bin/env ruby
# frozen_string_literal: true

# Copy overlays/<name>/ onto <name>/ without deleting upstream files.
# Overlay files remain untracked in the submodule working tree.

require "fileutils"
require "pathname"

ROOT = Pathname(__dir__).parent
OVERLAYS = ROOT / "overlays"

abort "overlays/ is missing; nothing to apply" unless OVERLAYS.directory?

applied = 0
OVERLAYS.children.sort.each do |overlay|
  next unless overlay.directory?

  target = ROOT / overlay.basename
  unless target.directory?
    warn "skip #{overlay.basename}: target checkout is missing (run make init-submodules)"
    next
  end

  overlay.find do |src|
    next if src.directory?

    rel = src.relative_path_from(overlay)
    dest = target / rel
    dest.dirname.mkpath
    FileUtils.cp(src, dest, preserve: true)
  end
  applied += 1
  puts "applied overlays/#{overlay.basename} -> #{overlay.basename}/"
end

puts "applied #{applied} overlay tree(s)"

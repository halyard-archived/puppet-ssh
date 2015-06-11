require 'puppet/util/errors'
require 'puppet/util/execution'
require 'octokit'

Puppet::Type.type(:github_ssh_key).provide :github do
  include Puppet::Util::Execution
  include Puppet::Util::Errors

  def exists?
    existing_id
  end

  def destroy
    api.remove_key(existing_id)
  end

  def create
    api.add_key(title, key)
  end

  private

  def api
    @api ||= Octokit::Client.new(
      access_token: Facter.value(:github_token),
      auto_paginate: true
    )
  end

  def existing_id
    match = api.keys.find { |x| x.key == key }
    return nil unless match
    match.id
  end

  def path
    @path ||= File.expand_path @resource[:path]
  end

  def key
    @key ||= File.read(path).strip
  end

  def default_title
    "#{Facter.value(:luser)}@#{Facter.value(:hostname)}"
  end

  def title
    @title ||= @resource[:title] || default_title
  end
end

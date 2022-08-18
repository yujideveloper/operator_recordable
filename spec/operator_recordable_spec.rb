# frozen_string_literal: true

require "spec_helper"
require "discard"
require "paranoia"

ActiveRecord::Base.configurations = {
  "test" => { "adapter" => "sqlite3", "database" => ":memory:" }
}
ActiveRecord::Base.establish_connection :test
ActiveRecord::Base.belongs_to_required_by_default = true # default for Rails 5.0+

class CreateAllTables < ActiveRecord::Migration::Current
  def self.up
    create_table(:operators) do |t|
      t.string :name
    end
    create_table(:accounts) do |t|
      t.string :email
      t.string :name
      t.datetime :created_at
      t.integer :created_by
      t.datetime :updated_at
      t.integer :updated_by
      t.datetime :deleted_at
      t.integer :deleted_by
    end
    create_table(:posts) do |t|
      t.string :title
      t.string :body
      t.integer :lock_version
      t.datetime :created_at
      t.integer :created_by
      t.datetime :updated_at
      t.integer :updated_by
      t.datetime :discarded_at
      t.integer :discarded_by
    end
    create_table(:comments) do |t|
      t.string :title
      t.string :body
      t.integer :lock_version
      t.datetime :created_at
      t.integer :created_by
      t.datetime :updated_at
      t.integer :updated_by
      t.datetime :deleted_at
      t.integer :deleted_by
    end
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include OperatorRecordable::Extension
end

class Operator < ApplicationRecord
end

module SoftDeletable
  def destroy
    with_transaction_returning_status do
      _run_destroy_callbacks do
        self.class.where(self.class.primary_key => self.id).update_all(deleted_at: Time.now)
      end
    end
    freeze
  end

  def deleted?
    !self.deleted_at.nil?
  end
end

class Account < ApplicationRecord
  include SoftDeletable

  record_operator_on :create, :update, :destroy
end

class Post < ApplicationRecord
  include Discard::Model

  record_operator_on :create, :update, :discard
end

class Comment < ApplicationRecord
  acts_as_paranoid

  record_operator_on :create, :update, :destroy
end

RSpec.describe OperatorRecordable do
  it "has a version number" do
    expect(OperatorRecordable::VERSION).not_to be nil
  end

  describe "creator" do
    after do
      Account.delete_all
      Operator.delete_all
    end

    it "should be assigned creator" do
      operator = Operator.create!(name: "op1")
      OperatorRecordable.operator = operator
      account = Account.create!
      expect(account.created_by).to eq operator.id
      expect(account.creator).to eq operator
    end
  end

  describe "updater" do
    after do
      Account.delete_all
      Operator.delete_all
    end

    it "should be assigned updater" do
      operator1 = Operator.create!(name: "op1")
      OperatorRecordable.operator = operator1
      account = Account.create!
      expect(account.updated_by).to eq operator1.id
      expect(account.updater).to eq operator1
      operator2 = Operator.create!(name: "op2")
      OperatorRecordable.operator = operator2
      account.update!(name: "test")
      expect(account.updated_by).to eq operator2.id
      expect(account.updater).to eq operator2
    end
  end

  describe "deleter" do
    context "with SoftDeletable" do
      after do
        Account.delete_all
        Operator.delete_all
      end

      it "should be assigned deleter" do
        operator1 = Operator.create!(name: "op1")
        OperatorRecordable.operator = operator1
        account = Account.create!
        expect(account.updated_by).to eq operator1.id
        expect(account.updater).to eq operator1
        operator2 = Operator.create!(name: "op2")
        OperatorRecordable.operator = operator2
        account.destroy!
        expect(account.deleted_by).to eq operator2.id
        expect(account.deleter).to eq operator2
        account.reload
        expect(account.deleted_by).to eq operator2.id
        expect(account.deleter).to eq operator2
      end
    end

    context "with paranoia" do
      after do
        Comment.delete_all
        Operator.delete_all
      end

      it "should be assigned deleter" do
        operator1 = Operator.create!(name: "op1")
        OperatorRecordable.operator = operator1
        comment = Comment.create!
        expect(comment.updated_by).to eq operator1.id
        expect(comment.updater).to eq operator1
        operator2 = Operator.create!(name: "op2")
        OperatorRecordable.operator = operator2
        comment.destroy!
        expect(comment.deleted_by).to eq operator2.id
        expect(comment.deleter).to eq operator2
        comment.reload
        expect(comment.deleted_by).to eq operator2.id
        expect(comment.deleter).to eq operator2
      end
    end
  end

  describe "discarder" do
    after do
      Post.delete_all
      Operator.delete_all
    end

    it "should be assigned discarder" do
      operator1 = Operator.create!(name: "op1")
      OperatorRecordable.operator = operator1
      post = Post.create!
      expect(post.updated_by).to eq operator1.id
      expect(post.updater).to eq operator1
      operator2 = Operator.create!(name: "op2")
      OperatorRecordable.operator = operator2
      post.discard!
      expect(post.discarded_by).to eq operator2.id
      expect(post.discarder).to eq operator2
      post.reload
      expect(post.discarded_by).to eq operator2.id
      expect(post.discarder).to eq operator2
    end
  end
end

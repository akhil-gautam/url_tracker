# frozen_string_literal: true

require 'httparty'

module Lib
  class HarperOrm
    def initialize
      @api_key = 'dummy'
      @api_url = 'dummy'
    end

    def create_table(table)
      body = {
        operation: 'create_table',
        schema: 'dev',
        table: table,
        hash_attribute: 'id'
      }
      post_req(body)
    end

    def create_record(table, params)
      body = {
        operation: 'insert',
        schema: 'dev',
        table: table,
        records: [params]
      }
      post_req(body)
    end

    def update(table, params)
      body = {
        operation: 'update',
        schema: 'dev',
        table: table,
        records: [params]
      }
      post_req(body)
    end

    def first(table)
      body = {
        operation: 'sql',
        sql: "SELECT * FROM dev.#{table} ORDER BY __createdtime__ LIMIT 1"
      }
      post_req(body).first
    end

    def find(table, id)
      record = find_by(table, 'id', id)
      if record.first.nil?
        raise StandardError, 'Record not found.'
      else
        record.first
      end
    end

    def find_by(table, by, value)
      body = {
        operation: 'sql',
        sql: "SELECT * FROM dev.#{table} where #{by} = '#{value}' ORDER BY __createdtime__ DESC"
      }
      post_req(body)
    end

    def all_records(table)
      body = {
        operation: 'sql',
        sql: "SELECT * FROM dev.#{table} ORDER BY __createdtime__"
      }
      post_req(body)
    end

    private

    def post_req(body)
      response = HTTParty.post(
        @api_url,
        body: body.to_json,
        headers: {
          "Authorization": "Basic #{@api_key}",
          "Content-Type": 'application/json'
        }
      )
      response.parsed_response
    end
  end
end

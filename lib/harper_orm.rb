require 'httparty'

module Lib
  class HarperOrm

    def initialize
      @api_key = "dXNlcl9oYXNobm9kZTpoYXNobm9kZTA5MDk"
      @api_url = "https://cd01-admin.harperdbcloud.com"
    end

    def create_table(table)
      body = {
        operation: "create_table",
        schema: "dev",
        table: table,
        hash_attribute: "id"
      }
      post_req(body)
    end

    def create_record(table, params)
      body = {
        operation: "insert",
        schema:  "dev",
        table: table,
        records: [ params ]
      }
      post_req(body)
    end

    def first(table)
      body = {
        operation: "sql",
        sql: "SELECT * FROM dev.#{table} ORDER BY __createdtime__ LIMIT 1"
      }
      post_req(body).first
    end

    def find(table, id)
      find_by(table, 'id', id).first
    end
    
    def find_by(table, by, value)
      body = {
        operation: "sql",
        sql: "SELECT * FROM dev.#{table} where #{by} = '#{value}'"
      }
      post_req(body)
    end

    def all_records(table)
      body = {
        operation: "sql",
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
          "Content-Type": "application/json"
        }
      )
      response.parsed_response
    end
  end
end

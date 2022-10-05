require 'sinatra'
require 'sinatra/json'
require 'json'
require 'securerandom'
require 'fileutils'

class MysteryApp < Sinatra::Base

    # Hello
    get '/' do
        content_type :json
        "Hello".to_json
    end

    notes = []

    # Get All Notes
    get '/notes' do
        content_type :json
        notes.to_json
    end

    # Add Note
    post '/notes' do
        json = JSON.parse(request.body.read)
        content = json['content']
        notes.push(content)
        index = notes.length - 1

        content_type :json
        { "index": index, "content": content }.to_json
    end    

    # Get Note By Index
    get '/notes/:index' do
        index = params[:index].to_i
        content_type :json
        { "index": index, "content": notes[index] }.to_json
    end

    # Replace Note
    put '/notes/:index' do
        index = params[:index].to_i
        json = JSON.parse(request.body.read)
        content = json['content']
        notes[index] = content;

        content_type :json
        { "index": index, "content": content }.to_json
    end

    # Add Note By Index
    post '/notes/:index' do
        index = params[:index].to_i
        content = JSON.parse(request.body.read)['content']
        notes.insert(index, content)

        content_type :json
        { "index": index, "content": content }.to_json
    end

    # Delete Note
    delete '/notes/:index' do
        notes.delete_at(params[:index].to_i)
        return 204
    end

    # Save Document
    post '/documents' do
        json = JSON.parse(request.body.read)
        content = json['content']
        docId = SecureRandom.uuid
        File.write("#{docId}.txt", content)

        content_type :json
        { "docId": docId }.to_json
    end
    
    # Get Document
    get '/documents/:docId' do
        docId = params[:docId]

        content = File.read("#{docId}.txt")

        content_type :json
        { "docId": docId, "content": content }.to_json
    end

    # A taxing mathematical operation
    get '/math/:num1/:num2/:amount' do
        num1 = params[:num1].to_i
        num2 = params[:num2].to_i
        amount = params[:amount].to_i

        amount.times do
            num1 * num2
        end
        content_type :json
        "Done".to_json
    end

    # Returns a list of randomly generated geo coordinates
    get '/coordinates/:amount' do
        amount = params[:amount].to_i
        coordinates = [];

        amount.times do
            lattitude = rand(-90...90)
            longitude = rand(-180...180)
            nsHemisphere = lattitude > 0 ? "North" : "South"
            ewHemisphere = longitude > 0 ? "East" : "West"
            coordinate = {"lattitude": lattitude, "longitude": longitude, "nsHemisphere": nsHemisphere, "ewHemisphere": ewHemisphere}
            coordinates.push(coordinate)
        end
        content_type :json
        { "coordinates": coordinates}.to_json
    end

    # Returns the factorial of the number
    memo = {};
    get '/factorial/:num' do
        num = params[:num].to_i

        previousComputation = memo[num]

        if previousComputation
            content_type :json
            { "memo": previousComputation}.to_json

        else
            product = 1;
            num.times do |i|
                product *= i + 1
            end
            memo[num] = product
            content_type :json
            { "product": product}.to_json
        end
    end
end

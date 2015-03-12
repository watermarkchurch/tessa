require 'spec_helper'

RSpec.describe UploadsController, type: :controller do

  describe "POST /" do
    shared_examples_for "successful upload creation" do
      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "contains valid json" do
        expect { json }.to_not raise_error
      end

      it "sets content_type to application/json" do
        expect(response.headers["Content-Type"]).to match(%r'application/json')
      end

      it "returns an upload_url" do
        expect(json['upload_url']).to_not be_nil
      end

      it "returns an upload_method" do
        expect(json['upload_method']).to_not be_nil
      end

      it "returns an asset_id" do
        expect(json['asset_id']).to_not be_nil
      end
    end

    context "with no parameters" do
      let(:params) { {} }

      it_behaves_like "successful upload creation" do
        before do
          run_request
        end
      end

      it "initializes an Upload object and calls save" do
        upload = instance_double(Upload)
        expect(Upload).to receive(:new).with({}).and_return(upload)
        expect(upload).to receive(:save)
        run_request
      end
    end

    context "with all params" do
      let(:params) {
        {
          "strategy" => "default",
          "name" => "filename",
          "size" => "123",
          "mime_type" => "text/plain",
        }
      }

      it_behaves_like "successful upload creation" do
        before do
          run_request
        end
      end

      it "initializes an Upload object with all params" do
        upload = double(Upload, save: true)
        expect(Upload).to receive(:new).with(params).and_return(upload)
        run_request
      end
    end

    context "with an invalid strategy" do
      let(:params) {
        {
          "strategy" => "not a strategy",
        }
      }

      it "does not create an asset" do
        run_request
        expect(DB[:assets].count).to eq(0)
      end

      it "returns a 422 error" do
        run_request
        expect(response.status).to eq(422)
      end
    end

    context "with an invalid param" do
      let(:params) {
        {
          "invalid_param" => "foo",
        }
      }

      it_behaves_like "successful upload creation" do
        before do
          run_request
        end
      end

      it "doesn't initialize Upload with any invalid params" do
        upload = double(Upload, save: true)
        expect(Upload).to receive(:new).with({}).and_return(upload)
        run_request
      end
    end

    def run_request
      post "/", params
    end
  end

end

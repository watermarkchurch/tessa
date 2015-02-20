require 'spec_helper'

RSpec.describe UploadsController, type: :controller do

  describe "POST /" do
    context "with no parameters" do
      let(:params) { {} }

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
          "strategy" => "foo",
          "acl" => "private",
          "name" => "filename",
          "size" => "123",
          "mime_type" => "text/plain",
        }
      }

      it "initializes an Upload object with all params" do
        expect(Upload).to receive(:new).with(params)
        run_request
      end
    end

    context "with an invalid param" do
      let(:params) {
        {
          "invalid_param" => "foo",
        }
      }

      it "doesn't initialize Upload with any invalid params" do
        expect(Upload).to receive(:new).with({})
        run_request
      end
    end

    def run_request
      post "/", params
    end
  end

end

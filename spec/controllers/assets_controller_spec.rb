require 'spec_helper'

RSpec.describe AssetsController, type: :controller do

  shared_examples_for "successful asset update" do
    it "returns success" do
      expect(response.status).to eq(200)
    end

    it "sets content_type to application/json" do
      expect(response.headers["Content-Type"]).to match(%r'application/json')
    end

    it "returns valid json" do
      expect { json }.to_not raise_error
    end

    it "returns an id" do
      expect(json['id']).to eq(asset.id)
    end

    it "returns status" do
      expect(json['status']).to eq('completed')
    end

    it "returns signed private_url"
    it "returns public_url"
    it "returns acl"
    it "returns strategy"
    it "returns meta"
  end

  describe "PATCH /:id/completed" do
    context "with an existing asset" do
      let!(:asset) { create(:asset) }

      it "finds the asset associated with this id" do
        expect(Asset).to receive(:find).with(asset.id.to_s).and_return(asset)
        run_request
      end

      it "updates asset status to :completed" do
        run_request
        new_asset = Asset.find(asset.id)
        expect(new_asset.status).to eq(:completed)
      end

      it_behaves_like "successful asset update" do
        before { run_request }
      end
    end

    context "with a non-existant asset" do
      before { run_request(0) }

      it "returns 404" do
        expect(response.status).to eq(404)
      end

      it "returns valid json" do
        expect { json }.to_not raise_error
      end

      it "sets content_type to application/json" do
        expect(response.headers["Content-Type"]).to match(%r'application/json')
      end
    end

    def run_request(id=asset.id)
      patch "/#{id}/completed"
    end
  end

end

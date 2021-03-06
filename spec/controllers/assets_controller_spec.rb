require 'spec_helper'

RSpec.describe AssetsController, type: :controller do

  shared_examples_for "successful asset response" do
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
      expect(json['status']).to eq(asset.status.to_s)
    end

    it "returns strategy" do
      expect(json['strategy']).to eq(asset.strategy_name)
    end

    it "returns meta" do
      expect(json['meta']).to eq(asset.meta)
    end

    it "returns created_at" do
      expect(json['created_at']).to eq(asset.created_at)
    end

    it "returns updated_at" do
      expect(json['updated_at']).to eq(asset.updated_at)
    end

    it "returns private_url" do
      expect(json['private_url']).to eq(asset.url.get)
    end

    it "returns private_download_url" do
      expect(json['private_download_url']).to eq(asset.url.get(response_content_disposition: "attachment"))
    end

    it "returns public_url" do
      expect(json['public_url']).to eq(asset.url.public)
    end
  end

  shared_examples_for "asset not found" do
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

      it_behaves_like "successful asset response" do
        before {
          run_request
          asset.status_id = Asset::STATUSES[:completed]
        }
      end
    end

    context "with a non-existant asset" do
      before { run_request(0) }
      it_behaves_like "asset not found"
    end

    def run_request(id=asset.id)
      patch "/#{id}/completed"
    end
  end

  describe "PATCH /:id/cancelled" do
    context "with an existing asset" do
      let!(:asset) { create(:asset) }

      it "finds the asset associated with this id" do
        expect(Asset).to receive(:find).with(asset.id.to_s).and_return(asset)
        run_request
      end

      it "updates asset status to :cancelled" do
        run_request
        new_asset = Asset.find(asset.id)
        expect(new_asset.status).to eq(:cancelled)
      end

      it_behaves_like "successful asset response" do
        before {
          run_request
          asset.status_id = Asset::STATUSES[:cancelled]
        }
      end
    end

    context "with a non-existant asset" do
      before { run_request(0) }
      it_behaves_like "asset not found"
    end

    def run_request(id=asset.id)
      patch "/#{id}/cancelled"
    end
  end

  describe "GET /:id" do
    context "with an existing asset" do
      let!(:asset) { create(:asset) }

      it "finds the asset associated with this id" do
        expect(Asset).to receive(:find).with(asset.id.to_s).and_return(asset)
        run_request
      end

      it_behaves_like "successful asset response" do
        before { run_request }
      end
    end

    context "with a non-existant asset" do
      before { run_request(0) }
      it_behaves_like "asset not found"
    end

    def run_request(id=asset.id)
      get "/#{id}"
    end
  end

  describe "GET /:id,:id..." do
    context "with two existing assets" do
      let!(:assets) { [create(:asset), create(:asset)] }

      it "returns both assets" do
        run_request
        expect(json.size).to eq(2)
        expect(json[0]['id']).to eq(assets[0].id)
        expect(json[1]['id']).to eq(assets[1].id)
      end

      it "ignores non-existant asset ids" do
        run_request([assets[0].id, "-1", "abc"])
        expect(json.size).to eq(1)
        expect(json[0]['id']).to eq(assets[0].id)
      end
    end

    def run_request(ids=assets.collect(&:id))
      get "/#{ids.join(",")}"
    end
  end

  describe "DELETE /:id" do
    context "with an existing asset" do
      let!(:asset) { create(:asset) }

      it_behaves_like "successful asset response" do
        before {
          run_request
          asset.status_id = Asset::STATUSES[:deleted]
        }
      end

      it "also includes :delete_url in response" do
        run_request
        expect(json['delete_url']).to eq(asset.url.delete)
      end

      it "sets the status to :deleted" do
        run_request
        new_asset = Asset.find(asset.id)
        expect(new_asset.status).to eq(:deleted)
      end
    end

    context "with a non-existant asset" do
      before { run_request(0) }
      it_behaves_like "asset not found"
    end

    def run_request(id=asset.id)
      delete "/#{id}"
    end
  end
end

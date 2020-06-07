require 'google/cloud/firestore'

@firestore = Google::Cloud::Firestore.new(
  project_id: "ENV['PROJECT_ID']",
  credentials: 'service-acount.json'
)

def fetch_all_docs
  puts 'List all collections'
  @firestore.cols.each do |col|
    puts col.collection_id
  end
end

# Use this method to delete a collection consisting of huge number of documents(without any sub-collections) in batches
def delete_collection
  collection_ref = @firestore.col 'collection-name' # In case of nested structure, give full path of the collection
  1.upto(100) do |n|
    query = collection_ref.limit(100)

    @firestore.batch do |b|
      query.get do |document_snapshot|
        puts "Deleting document #{document_snapshot.document_id}."
        document_ref = document_snapshot.ref
        b.delete document_ref
      end
    end
    puts "Finished deleting batch number #{n}"
  end
end

require 'spec_helper'

describe Knodes::Client do
	before do
		Knodes.configure do |config|
			config.customer_id = ENV['CUSTOMER_ID']
			config.customer_secret = ENV['CUSTOMER_SECRET']
		end
	end			

	context "Client" do
		it "should make a client" do
			c = Knodes.client
			c.should be_an_instance_of (Knodes::Client)
		end

		it "should allow me to set configuration in a block " do
			Knodes.configure do |config|
				config.customer_id = "foo"
				config.customer_secret = "bar"
			end
			#puts Knodes.customer_id
			Knodes.customer_id.should == "foo"
		end

		it "should instantiate using default configuration values" do
		    c = Knodes::Client.new
			c.endpoint.should == "https://api.knod.es/"
	  	end

		it "should instantiate using specified configuration values" do
			c = Knodes.client(:customer_id=>"foo", :customer_secret=>"bar")
			c.customer_id.should == "foo" 
			c.customer_secret.should == "bar"
		end

	end

	context "Customers" do
		before do
			@test_app_id = ENV['TEST_APP_ID']
			@test_app_secret = ENV['TEST_APP_SECRET']
			#Knodes = Knodes.client(:customer_id=>@test_customer_id, :customer_secret=>@test_customer_secret)	
		end

		it "should connect to the customer endpoint" do
			response = Knodes.customer
			#puts response
			#puts "\nCustomer App Name: #{response.name}\n"
			response.should have_key(:name)
		end

		it "should disconnect a customer network app" do
			#response = Knodes.customer_disconnect(:network=>"facebook")
			#puts response.network_apps
			pending("don't want to run this every time")
			#response.network_apps.should_not have_key(:facebook)
		end

		it "should connect a customer network app" do
			#response = Knodes.customer_connect(:network=>"facebook", :id=>@test_app_id, :secret=>@test_app_secret)
			#puts response.network_apps
			pending("don't want to run this every time")
			#response.network_apps.should have_key(:facebook)
		end
	end

	context "Users" do
		before do
			@test_user_id = ENV['TEST_USER_ID']
			@test_network_id = ENV['TEST_NETWORK_ID']
			@test_network_token = ENV['TEST_NETWORK_TOKEN']
			#@c = Knodes.client(:customer_id=>@test_customer_id, :customer_secret=>@test_customer_secret)	
		end

		it "should return a user" do
			response = Knodes.user(:user_id=>@test_user_id)
			#puts "\nUser Name: #{response.name}"
			#puts response.inspect
			response.should have_key(:name)
		end

		it "should fail gracefully with an incorrect id" do
			lambda {
				Knodes.user(:user_id=>"yo_i_got_a_fake_id")
			}.should raise_error(Knodes::NotFound, "invalid action")
		end

		it "should disconnect a user's network account" do
			#response = Knodes.user_disconnect(:user_id=>@test_user_id, :network=>"facebook", :network_id=>@test_network_id)
			#puts "User networks: #{response.networks}"
			#pending("don't want to run this every time")
			response.networks.should_not have_key(:facebook)
		end

		it "should connect a user's network account" do
			response = Knodes.user_connect(:network=>"facebook", :network_id=>@test_network_id, :token=>@test_network_token)
			puts response.inspect
			#pending("don't want to run this every time")
			response.networks.should have_key(:facebook)
		end

		it "should notify_inactive" do
			response = Knodes.user_notify_inactive(:user_id=>@test_user_id)
			#puts "\nNotify inactive status: #{response}"
			response.should == 200
		end

		it "should notify_active" do
			response = Knodes.user_notify_active(:user_id=>@test_user_id)
			#puts "\nNotify active user name: #{response.name}"
			#puts "\nNotify active ready status: #{response.ready}"
			response.should have_key(:name)
			response.ready.should == "ok" || response.ready.should == "indexing"
		end

		it "should return ready status" do
			response = Knodes.user_ready(:user_id=>@test_user_id)
			#puts "\nReady status: #{response}"
			response.should == "ok" || response.ready.should == "indexing"
		end

		it "should initiate a user index" do
			#response = Knodes.user_do_index(:user_id=>@test_user_id)
			#puts "\nUser index status: #{response}"
			#response.should == 200
			pending ("dont want to hit knodes too hard")
		end

		it "should update a users email address" do
			response = Knodes.user_update(:user_id=>@test_user_id, :email=>"test@example.com")
			response.email.should == "test@example.com"
		end
	end

	context "People" do
		before do 
			@test_user_id = ENV['TEST_USER_ID']
			@test_person_id = ENV['TEST_PERSON_ID']
			#@c = Knodes.client(:customer_id=>@test_customer_id, :customer_secret=>@test_customer_secret)	
		end

		it "should return a person" do
			response = Knodes.person(:user_id=>@test_user_id, :person_id=>@test_person_id)
			#puts response.inspect
			response.should have_key(:name)
		end

		it "should search for people" do
			response = Knodes.people_search(:user_id=>@test_user_id, :person_id=>"self", :q=>"Person")
			#puts response.results
			response.results.should_not be_empty
		end
		
		it "should search for people and fail gracefully" do
			response = Knodes.people_search(:user_id=>@test_user_id, :q=>"Unknown")
			#puts response
			response.should have_key(:total)
		end

		it "should find people associated with self" do
			response = Knodes.person_people(:user_id=>@test_user_id, :person_id=>"self")	
			#puts response.inspect
			response.results.should_not be_empty
		end

		it "should find people associated with a person" do
			response = Knodes.person_people(:user_id=>@test_user_id, :person_id=>@test_person_id)	
			#puts response.inspect
			#response.results.should_not be_empty
			pending "further testing"
		end

		it "should find documents associated with a person" do
			response = Knodes.person_documents(:user_id=>@test_user_id, :person_id=>@test_person_id, :q=>"")
			response.should have_key(:total)
		end

		it "should find locations associated with a person" do
			response = Knodes.person_locations(:user_id=>@test_user_id, :person_id=>@test_person_id, :q=>"")
			response.should have_key(:total)
		end

		it "should find companies associated with a person" do
			response = Knodes.person_companies(:user_id=>@test_user_id, :person_id=>@test_person_id, :q=>"")
			response.should have_key(:total)
		end

		it "should find schools associated with a person" do
			response = Knodes.person_schools(:user_id=>@test_user_id, :person_id=>@test_person_id, :q=>"")
			response.should have_key(:total)
		end
	end

	context "Documents" do
		before do 
			@test_user_id = ENV['TEST_USER_ID']
			@test_person_id = ENV['TEST_PERSON_ID']
			@test_doc_id = ENV['TEST_DOC_ID']
			#@c = Knodes.client(:customer_id=>@test_customer_id, :customer_secret=>@test_customer_secret)	
		end

		it "should return a document" do
			response = Knodes.document(:user_id=>@test_user_id, :doc_id=>@test_doc_id)
			#puts response.inspect
			response.should have_key(:id)
		end

		it "should search for documents" do
			response = Knodes.documents_search(:user_id=>@test_user_id, :q=>"profile")
			#puts response.results
			response.total.should > 0
		end
		
		it "should search for documents and fail gracefully" do
			response = Knodes.documents_search(:user_id=>@test_user_id, :type=> "document", :q=>"Unknown")
			#puts response
			response.should have_key(:total)
		end

		it "should find documents associated with self" do
			response = Knodes.documents_search(:user_id=>@test_user_id, :q=>"")	
			#puts response.inspect
			response.total.should > 0
		end

		it "should find people associated with a document" do
			response = Knodes.document_people(:user_id=>@test_user_id, :doc_id=>@test_doc_id) 
			#puts response.inspect
			pending "finding a document with associated people"
			response.total.should > 0
		end

		it "should find locations associated with a document" do
			response = Knodes.document_locations(:user_id=>@test_user_id, :doc_id=>@test_doc_id)
			#puts response.inspect
			pending "finding a document with a location"
			response.total.should > 0
		end
	end

	context "Locations" do
		before do 
			@test_user_id = ENV['TEST_USER_ID'] 
			@test_person_id = ENV['TEST_PERSON_ID'] 
			@test_location_id = ENV['TEST_LOCATION_ID'] 
			#@c = Knodes.client(:customer_id=>@test_customer_id, :customer_secret=>@test_customer_secret)	
		end

		it "should return a location" do
			response = Knodes.location(:user_id=>@test_user_id, :location_id=>@test_location_id)
			#puts response.inspect
			response.should have_key(:id)
		end

		it "should search for locations" do
			response = Knodes.locations_search(:user_id=>@test_user_id, :q=>"New York")
			#puts response.results
			response.total.should > 0
		end
		
		it "should search for locations and fail gracefully" do
			response = Knodes.locations_search(:user_id=>@test_user_id, :type=> "location", :q=>"Unknown")
			#puts response
			response.should have_key(:total)
		end

		it "should find locations associated with self" do
			response = Knodes.locations_search(:user_id=>@test_user_id, :q=>"")	
			#puts response.inspect
			response.total.should > 0
		end

		it "should find people associated with a location" do
			response = Knodes.location_people(:user_id=>@test_user_id, :location_id=>@test_location_id) 
			#puts response.inspect
			#response.total.should > 0
			pending "finding a location with people"
		end

		it "should find documents associated with a location" do
			response = Knodes.location_documents(:user_id=>@test_user_id, :location_id=>@test_location_id)
			#puts response.inspect
			#response.total.should > 0
			pending "finding a location with documents"
		end
	end

	context "Companies" do
		before do 
			@test_user_id = ENV['TEST_USER_ID']
			@test_person_id = ENV['TEST_PERSON_ID']
			@test_company_id = ENV['TEST_COMPANY_ID']
			#@c = Knodes.client(:customer_id=>@test_customer_id, :customer_secret=>@test_customer_secret)	
		end

		it "should return a company" do
			pending "finding a company"
			response = Knodes.company(:user_id=>@test_user_id, :company_id=>@test_company_id)
			#puts response.inspect
			#response.should have_key(:id)
			
		end

		it "should search for companies" do
			pending "finding a company"
			response = Knodes.companies_search(:user_id=>@test_user_id, :q=>"New York")
			#puts response.results
			#response.total.should > 0
		end
		
		it "should search for companies and fail gracefully" do
			response = Knodes.companies_search(:user_id=>@test_user_id, :type=> "company", :q=>"Unknown")
			#puts response
			response.should have_key(:total)
		end

		it "should find companies associated with self" do
			pending "finding a company"
			response = Knodes.companies_search(:user_id=>@test_user_id, :q=>"")	
			#puts response.inspect
			#response.total.should > 0
		end

		it "should find people associated with a company" do
			pending "finding a company"
			response = Knodes.company_people(:user_id=>@test_user_id, :company_id=>@test_company_id) 
			#puts response.inspect
			#response.total.should > 0
		end
	end

	context "Schools" do
		before do 
			@test_user_id = ENV['TEST_USER_ID'] #
			@test_person_id = ENV['TEST_PERSON_ID'] 
			@test_school_id = ENV['TEST_SCHOOL_ID'] 
			#@c = Knodes.client(:customer_id=>@test_customer_id, :customer_secret=>@test_customer_secret)	
		end

		it "should return a school" do
			response = Knodes.school(:user_id=>@test_user_id, :school_id=>@test_school_id)
			# puts response.inspect
			response.should have_key(:id)
			
		end

		it "should search for schools" do
			response = Knodes.schools_search(:user_id=>@test_user_id, :q=>"Rensselaer")
			#puts response.results
			response.total.should > 0
		end
		
		it "should search for schools and fail gracefully" do
			response = Knodes.schools_search(:user_id=>@test_user_id, :type=> "school", :q=>"Unknown")
			#puts response
			response.should have_key(:total)
		end

		it "should find schools associated with self" do
			response = Knodes.schools_search(:user_id=>@test_user_id, :q=>"")	
			#puts response.inspect
			response.total.should > 0
		end

		it "should find people associated with a school" do
			response = Knodes.school_people(:user_id=>@test_user_id, :school_id=>@test_school_id) 
			#puts response.inspect
			response.total.should > 0
		end
	end

end






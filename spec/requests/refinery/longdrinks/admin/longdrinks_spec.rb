# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Longdrinks" do
    describe "Admin" do
      describe "longdrinks" do
        login_refinery_user

        describe "longdrinks list" do
          before do
            FactoryGirl.create(:longdrink, :title => "UniqueTitleOne")
            FactoryGirl.create(:longdrink, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.longdrinks_admin_longdrinks_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.longdrinks_admin_longdrinks_path

            click_link "Add New Longdrink"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Longdrinks::Longdrink.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::Longdrinks::Longdrink.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:longdrink, :title => "UniqueTitle") }

            it "should fail" do
              visit refinery.longdrinks_admin_longdrinks_path

              click_link "Add New Longdrink"

              fill_in "Title", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Longdrinks::Longdrink.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:longdrink, :title => "A title") }

          it "should succeed" do
            visit refinery.longdrinks_admin_longdrinks_path

            within ".actions" do
              click_link "Edit this longdrink"
            end

            fill_in "Title", :with => "A different title"
            click_button "Save"

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content("A title")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:longdrink, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.longdrinks_admin_longdrinks_path

            click_link "Remove this longdrink forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Longdrinks::Longdrink.count.should == 0
          end
        end

      end
    end
  end
end
